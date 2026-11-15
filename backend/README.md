# CodeBox - Backend Module (Systems & Judge Engine)

This directory contains the production-grade C++17 execution engine, REST API server, and SQLite3 database integration for CodeBox.

---

## 🏗️ Architecture & Component Overview

```
                   +------------------------+
                   |   front_end.html (SPA) |
                   +-----------+------------+
                               | (HTTP / REST)
                               v
                     +-------------------+
                     |  httplib::Server  |
                     +---------+---------+
                               |
                               v
                     +-------------------+
                     |    ApiHandler     |
                     +---+-----------+---+
                         |           |
             (DB Queries)|           |(Task Dispatch)
                         v           v
           +-----------------+   +--------------------+
           | DatabaseManager |   |   QueueScheduler   |
           +-----------------+   +---------+----------+
                                           | (Task Queue)
                                           v
                                 +--------------------+
                                 |  Worker Threads(3) |
                                 +---------+----------+
                                           |
                                           v
                                 +--------------------+
                                 |   DockerSandbox    |
                                 +---------+----------+
                                           |
                                           v
                                 +--------------------+
                                 |  ResultEvaluator   |
                                 +--------------------+
```

---

## 📁 Source Files & Responsibilities

| File | Primary Responsibility |
| :--- | :--- |
| `main.cpp` | Server entrypoint, database auto-initialization, signal handling (`SIGINT`/`SIGTERM`), and route registration. |
| `ApiHandler.h/.cpp` | HTTP routing, JSON payload parsing, authentication endpoint logic, problem catalog handler, playground runner, and multi-testcase judge execution. |
| `DatabaseManager.h/.cpp` | Thread-safe SQLite3 singleton, WAL mode, foreign key enforcement, schema initialization, and transactional queries. |
| `QueueScheduler.h/.cpp` | Thread pool managing 3 worker threads with First-Come First-Served (FCFS) task execution using `std::mutex` and `std::condition_variable`. |
| `DockerSandbox.h/.cpp` | Secure isolated container execution inside Docker with 256MB memory cap (`--memory=256m`), cgroups isolation, network disabling (`--network none`), and 2.0s SIGKILL watchdog timer (`timeout -s KILL 2.0s`). |
| `FileManager.h/.cpp` | Atomic temporary file creation in `/tmp`, source code writing, cleanup, and Java class/file synchronization. |
| `LanguageConfig.h/.cpp` | Language definitions, compilers, runtime flags, file extensions, and execution commands for **C (GCC)**, **C++17**, **Python 3**, and **Java 17**. |
| `ResultEvaluator.h/.cpp` | Online judge verdict engine determining **Accepted**, **Wrong Answer**, **Time Limit Exceeded**, **Compilation Error**, and **Runtime Error** with trailing whitespace normalization. |
| `Headers.h` | Umbrella header consolidating standard library headers, platform conditionals, and class forward declarations. |
| `httplib.h` | Lightweight, single-header C++11 HTTP/HTTPS library by Yuji Hirose. |
