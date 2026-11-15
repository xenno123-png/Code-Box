#include "Headers.h"

QueueScheduler::QueueScheduler() : running(false), maxWorkers(3) {}

QueueScheduler::~QueueScheduler() {
    stop();
}

void QueueScheduler::start() {
    lock_guard<mutex> lock(mtx);
    if (running) return;
    running = true;
    for (int i = 0; i < maxWorkers; i++) {
        workers.emplace_back(&QueueScheduler::workerLoop, this);
    }
    cout << "QueueScheduler: started " << maxWorkers << " worker threads" << endl;
}

void QueueScheduler::enqueue(shared_ptr<Task> task) {
    if (!task) return;

    {
        lock_guard<mutex> lock(mtx);
        if (!running) {
            lock_guard<mutex> taskLock(task->mtx);
            task->status = "Runtime Error";
            task->stderr = "Server is shutting down; task rejected.";
            task->finished = true;
            task->cv.notify_all();
            return;
        }
        taskQueue.push(task);
    }
    cv.notify_one();
    cout << "QueueScheduler: task " << task->id << " enqueued" << endl;
}

void QueueScheduler::stop() {
    {
        lock_guard<mutex> lock(mtx);
        if (!running) return;
        running = false;
    }
    cv.notify_all();

    for (auto& t : workers) {
        if (t.joinable()) t.join();
    }
    workers.clear();
    cout << "QueueScheduler: stopped" << endl;
}

// Worker loop: wait for work, pull next task, and execute it
void QueueScheduler::workerLoop() {
    while (true) {
        shared_ptr<Task> task;
        {
            unique_lock<mutex> lock(mtx);
            cv.wait(lock, [this] { return !running || !taskQueue.empty(); });

            if (!running && taskQueue.empty()) break;

            task = taskQueue.front();
            taskQueue.pop();
        }

        if (task) {
            processTask(task);
        }
    }
}

// Pipeline: write code to disk -> run in Docker -> evaluate result -> notify caller
void QueueScheduler::processTask(shared_ptr<Task> task) {
    cout << "QueueScheduler: processing task " << task->id << endl;

    FileManager fm;
    DockerSandbox sandbox;
    ResultEvaluator evaluator;
    LanguageConfig langConfig;

    string sourceFile;
    string inputFile;

    struct FileGuard {
        FileManager& mgr;
        string& sPath;
        string& iPath;
        ~FileGuard() { 
            if (!sPath.empty()) mgr.deleteFile(sPath); 
            if (!iPath.empty()) mgr.deleteFile(iPath);
        }
    } fileGuard{fm, sourceFile, inputFile};

    try {
        string ext = langConfig.getFileExtension(task->language);
        if (ext.empty()) {
            lock_guard<mutex> lock(task->mtx);
            task->status = "Runtime Error";
            task->stderr = "Unsupported language: " + task->language;
            task->finished = true;
            task->cv.notify_all();
            return;
        }

        sourceFile = fm.saveCodeToFile(task->code, ext);
        if (sourceFile.empty()) {
            lock_guard<mutex> lock(task->mtx);
            task->status = "Runtime Error";
            task->stderr = "Failed to save code to disk";
            task->finished = true;
            task->cv.notify_all();
            return;
        }

        if (!task->stdinInput.empty()) {
            inputFile = fm.saveInputToFile(task->stdinInput);
        }

        auto start = chrono::steady_clock::now();
        DockerSandbox::CommandResult exec = sandbox.runCode(task->language, sourceFile, inputFile);
        auto end = chrono::steady_clock::now();
        int elapsedMs = static_cast<int>(chrono::duration_cast<chrono::milliseconds>(end - start).count());

        string evaluatedStatus = evaluator.evaluate(exec, task->language);

        {
            lock_guard<mutex> lock(task->mtx);
            task->status = evaluatedStatus;
            task->stdout = exec.stdout;
            task->stderr = exec.stderr;
            task->executionTimeMs = elapsedMs;
            task->finished = true;
        }
        task->cv.notify_all();

    } catch (const exception& e) {
        cerr << "QueueScheduler: error in task " << task->id << ": " << e.what() << endl;
        lock_guard<mutex> lock(task->mtx);
        task->status = "Runtime Error";
        task->stderr = "Internal worker error: " + string(e.what());
        task->finished = true;
        task->cv.notify_all();
    } catch (...) {
        cerr << "QueueScheduler: unknown error in task " << task->id << endl;
        lock_guard<mutex> lock(task->mtx);
        task->status = "Runtime Error";
        task->stderr = "Unknown internal worker error";
        task->finished = true;
        task->cv.notify_all();
    }
}