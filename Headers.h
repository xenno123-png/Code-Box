#pragma once

// ==============================================================================
// CodeBox: Master Umbrella Header (Headers.h)
// Consolidates standard libraries, system headers, and project components.
// ==============================================================================

// Standard Library Headers
#include <iostream>            // Console input/output operations (cout, cerr)
#include <string>              // String class for code, language names, and logs
#include <sstream>             // String streams for building JSON responses
#include <vector>              // Dynamic array container (stores worker threads)
#include <queue>               // FIFO task queue for submissions
#include <unordered_map>       // Hash maps for key-value lookups
#include <memory>              // Smart pointers (shared_ptr, unique_ptr) for memory safety
#include <thread>              // C++17 std::thread for background worker pool
#include <mutex>               // Mutex and lock_guard to prevent race conditions
#include <condition_variable>  // Signals workers to sleep when idle and wake on tasks
#include <chrono>              // Nanosecond timestamps and execution timeouts
#include <functional>          // Callable objects and std::function
#include <fstream>             // File streams (ifstream, ofstream) to read/write disk
#include <filesystem>          // File system path utilities
#include <cstdlib>             // General standard library functions
#include <atomic>              // Lock-free atomic counters for collision-free IDs
#include <csignal>             // OS signal handling for graceful shutdown (SIGINT / Ctrl+C)
#include <cctype>              // Character classification and casing (tolower, isalnum)
#include <algorithm>           // Standard algorithms (std::transform)
#include <cstdio>              // C file operations (remove, popen, pclose)

// Cross-Platform OS Headers & Process Macros
#ifdef _WIN32
#include <process.h>           // Windows process management (_getpid)
#include <direct.h>            // Windows directory operations (_mkdir, _rmdir)
#define POPEN _popen
#define PCLOSE _pclose
#define GET_PID() _getpid()
#define MKDIR(path) _mkdir(path)
#define RMDIR(path) _rmdir(path)
#else
#include <unistd.h>            // POSIX system calls (getpid)
#include <sys/wait.h>          // Process status macros (WIFEXITED, WTERMSIG for SIGKILL/137)
#include <sys/stat.h>          // POSIX directory creation permissions (mkdir)
#define POPEN popen
#define PCLOSE pclose
#define GET_PID() getpid()
#define MKDIR(path) mkdir(path, 0777)
#define RMDIR(path) rmdir(path)
#endif

// Third-party HTTP server library (suppress third-party warnings)
#if defined(__GNUC__) || defined(__clang__)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wold-style-cast"
#endif
#include "httplib.h"           // Lightweight single-header C++ HTTP/REST server library
#if defined(__GNUC__) || defined(__clang__)
#pragma GCC diagnostic pop
#endif

// Project Headers in Dependency Order
#include "LanguageConfig.h"    // 4-language rules, file extensions, and docker run commands
#include "ResultEvaluator.h"   // Evaluates exit codes and output into verdicts (Accepted, TLE, etc.)
#include "FileManager.h"       // Saves submitted code to /tmp and cleans it up after execution
#include "DockerSandbox.h"     // Executes Docker container commands and pipes stdout/stderr
#include "QueueScheduler.h"    // FCFS task queue and 3-worker thread pool
#include "ApiHandler.h"        // REST API routes (/run, /health) and JSON request handling

using namespace std;
