# CodeBox v3.0: Online Coding & Judge Platform

[![C++17](https://img.shields.io/badge/C%2B%2B-17-00599C?logo=c%2B%2B&logoColor=white)](https://en.cppreference.com/w/cpp/17)
[![Docker](https://img.shields.io/badge/Docker-Sandboxed-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![SQLite3](https://img.shields.io/badge/SQLite-3NF%20Relational-003B57?logo=sqlite&logoColor=white)](https://www.sqlite.org/)
[![License](https://img.shields.io/badge/License-Academic-green.svg)]()

> A production-grade, containerized online coding platform and automated multi-test-case judge system built with modern C++17, Docker cgroups sandboxing, strict 3NF relational SQLite database, and a responsive Monaco Editor Single Page Application (SPA).

---

## 🚀 Key Features

- **Isolated Docker Sandbox**:
  - Executes untrusted user code inside ephemeral Docker containers (`--network none`, read-only limits).
  - Hard memory cap enforced via Linux cgroups (`--memory=256m`).
  - Watchdog execution timer (`timeout -s KILL 2.0s`) preventing infinite loops and fork bombs.
- **Multi-Threaded Queue Scheduler**:
  - Custom thread pool running 3 concurrent FCFS worker threads.
  - Zero busy-waiting using `std::mutex` and `std::condition_variable`.
- **Strict 3NF Relational Database**:
  - SQLite3 engine tuned with Write-Ahead Logging (`PRAGMA journal_mode = WAL;`) and busy timeout resolution (`PRAGMA busy_timeout = 5000;`).
  - 7 normalized tables eliminating data redundancy and update anomalies.
  - 30+ curated DSA problems pre-seeded with compilable starter templates for **C (GCC)**, **C++17**, **Python 3**, and **Java 17**.
- **Automated Multi-Test-Case Judge Engine**:
  - Evaluates user submissions against public sample and hidden test cases.
  - Generates standard verdicts: **Accepted (AC)**, **Wrong Answer (WA)**, **Time Limit Exceeded (TLE)**, **Memory Limit Exceeded (MLE)**, **Compilation Error (CE)**, and **Runtime Error (RE)**.
  - Trailing whitespace and CRLF vs LF sanitization.
- **Responsive Web UI (`frontend/front_end.html`)**:
  - Mandatory Authentication Gate with zero-guest leakage and persistent sessions.
  - Collapsible DSA problem catalog with difficulty/category filtering.
  - Coding Platform with integrated VS Code-style `Terminal / Output` console and live standard input (`stdin:`) prompt.
  - Mouse-draggable split-pane resizers (`col-resize` and `row-resize`) with transparent drag shields for smooth 60fps Monaco layout updates.

---

## 📁 Repository Structure

```
Code_Box/
├── backend/                       # Core C++17 Systems & Judge Engine
│   ├── main.cpp                   # Server lifecycle, signal handlers & routing
│   ├── ApiHandler.h/.cpp          # REST API endpoints & multi-test judge loop
│   ├── DatabaseManager.h/.cpp     # Thread-safe SQLite3 singleton & ORM queries
│   ├── QueueScheduler.h/.cpp      # 3-worker FCFS thread pool
│   ├── DockerSandbox.h/.cpp       # Container isolation (256MB RAM / 2.0s watchdog)
│   ├── LanguageConfig.h/.cpp      # Compiler rules for C, C++, Python, Java
│   ├── ResultEvaluator.h/.cpp     # Verdict evaluator & whitespace normalizer
│   ├── FileManager.h/.cpp         # Ephemeral disk file management in /tmp
│   ├── Headers.h                  # Master umbrella header
│   ├── httplib.h                  # Embedded C++ HTTP server
│   ├── Makefile                   # Subdirectory makefile
│   └── README.md                  # Backend architecture guide
│
├── database/                      # Relational Database Tier
│   ├── schema.sql                 # Strict 3NF DDL (7 tables, foreign keys, indexes)
│   ├── seed_problems.sql          # 30 DSA problems + 4-language starter templates
│   ├── queries.sql                # Production SQL queries (Leaderboard, catalog JOINs)
│   └── README.md                  # Database documentation
│
├── frontend/                      # User Interface Tier
│   ├── front_end.html             # Monaco Editor SPA & Dark Theme UI
│   └── README.md                  # Frontend architecture guide
│
├── DETAILS/                       # Project Documentation & Systems Blueprint
│   └── CodeBox.pdf                # Master Technical & Defense Guide (Overview, OS, DBMS)
│
├── Makefile                       # Master build orchestration
├── .gitignore                     # Git ignore rules (binaries, .db, obj/)
└── README.md                      # Project master documentation
```

---

## 🛠️ Quickstart & Setup Guide

### 1. Prerequisites (Linux / WSL2)
Ensure GCC (C++17), Make, SQLite3 development headers, and Docker are installed:
```bash
sudo apt update
sudo apt install -y g++ make libsqlite3-dev docker.io
```

### 2. Compile the Server
From the project root directory, run:
```bash
make clean && make release
```
This automatically compiles `backend/*.cpp` with `-O2 -std=c++17 -lsqlite3 -pthread` and links `./codebox_server`.

### 3. Start CodeBox
```bash
./codebox_server
```
The server will automatically initialize `database/codebox.db`, apply the 3NF schema, seed all 30 problems, launch the 3 worker threads, and start listening on `http://0.0.0.0:8080`.

### 4. Open in Browser
Visit **`http://localhost:8080`** in your browser. Register an account or log in to access the platform.

---

## 👥 Project Team (ayush908828)

- **Ayush Negi** *(Team Lead)* — Roll: `2418394` | ID: `240111265`
- **Dhruv Bhatt** — Roll: `2418455` | ID: `240211470`
- **Devansh Joshi** — Roll: `2418442` | ID: `240211468`
- **Dibyanshu Negi** — Roll: `2418461` | ID: `240111185`
- **Kartik Rawat** — Roll: `2418578` | ID: `240111227`

**Academic Degree:** B.Tech Computer Science & Engineering (Systems & Cloud Track)
