#pragma once

#include <condition_variable>
#include <memory>
#include <mutex>
#include <queue>
#include <string>
#include <thread>
#include <vector>

using namespace std;

// Represents a single code execution job
struct Task {
    string id;
    string language;
    string code;
    string stdinInput;
    int executionTimeMs = 0;
    string status;    // "Accepted", "Time Limit Exceeded", etc.
    string stdout;
    string stderr;
    bool finished = false;

    mutex mtx;
    condition_variable cv;
};

// Thread-safe FCFS queue with worker thread pool
class QueueScheduler {
public:
    QueueScheduler();
    ~QueueScheduler();

    QueueScheduler(const QueueScheduler&) = delete;
    QueueScheduler& operator=(const QueueScheduler&) = delete;

    void enqueue(shared_ptr<Task> task);
    void start();
    void stop();

private:
    void workerLoop();
    void processTask(shared_ptr<Task> task);

    queue<shared_ptr<Task>> taskQueue;
    mutex mtx;
    condition_variable cv;
    bool running = false;
    int maxWorkers = 3;
    vector<thread> workers;
};