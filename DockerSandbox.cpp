#include "Headers.h"

// Unique counter for temp stderr capture files
static atomic<uint64_t> sandboxCmdCounter{0};

// 1MB max output cap to prevent runaway loops from exhausting memory
static constexpr size_t MAX_OUTPUT_BYTES = 1024 * 1024;

DockerSandbox::CommandResult DockerSandbox::executeCommand(const string& shellCommand) {
    CommandResult result;
    result.exitCode = 0;

    // Direct stderr to a unique temporary file
    uint64_t cmdId = sandboxCmdCounter.fetch_add(1, memory_order_relaxed);
    auto timestamp = chrono::steady_clock::now().time_since_epoch().count();
    string errFile = "/tmp/codebox_err_" + to_string(GET_PID()) + "_" + to_string(timestamp) + "_" + to_string(cmdId) + ".txt";

    // Clean up the temp stderr file on scope exit
    struct ErrFileGuard {
        string path;
        ~ErrFileGuard() { if (!path.empty()) remove(path.c_str()); }
    } errGuard{errFile};

    string fullCommand = shellCommand + " 2>" + errFile;

    // Run command and pipe its stdout
    FILE* pipe = POPEN(fullCommand.c_str(), "r");
    if (!pipe) {
        result.stderr = "Failed to execute command";
        result.exitCode = -1;
        return result;
    }

    // Read stdout up to the 1MB cap
    char buffer[4096];
    bool truncated = false;
    while (fgets(buffer, sizeof(buffer), pipe) != nullptr) {
        if (result.stdout.size() < MAX_OUTPUT_BYTES) {
            result.stdout += buffer;
        } else if (!truncated) {
            result.stdout += "\n[Output limit exceeded: truncated at 1MB]";
            truncated = true;
        }
    }

    // Wait for the command to finish and grab the exit code
    int status = PCLOSE(pipe);

#ifdef _WIN32
    result.exitCode = status;
#else
    if (status == -1) {
        result.exitCode = -1;
    } else if (WIFEXITED(status)) {
        result.exitCode = WEXITSTATUS(status);
    } else if (WIFSIGNALED(status)) {
        result.exitCode = 128 + WTERMSIG(status); // 137 on SIGKILL (cgroup OOM or timeout kill)
    } else {
        result.exitCode = status;
    }
#endif

    // Read whatever got printed to stderr
    ifstream errStream(errFile, ios::in | ios::binary);
    if (errStream.is_open()) {
        stringstream ss;
        ss << errStream.rdbuf();
        result.stderr = ss.str();
        if (result.stderr.size() > MAX_OUTPUT_BYTES) {
            result.stderr.resize(MAX_OUTPUT_BYTES);
            result.stderr += "\n[Stderr limit exceeded: truncated at 1MB]";
        }
        errStream.close();
    }

    return result;
}

DockerSandbox::CommandResult DockerSandbox::runCode(const string& language, const string& sourceFile) {
    LanguageConfig langConfig;
    string dockerCommand = langConfig.getRunCommand(language, sourceFile);
    return executeCommand(dockerCommand);
}