# CodeBox: Header Files Viva Cheat Sheet 🚀
*(Teacher / Examiner ke saamne bolne ke liye super-simple 1-line guide)*

---

## 📁 PART 1: Project Ki Apni Header Files (Custom Headers)
*(Har file ka sirf 1 main kaam yaad rakho)*

| Header File | 1-Line Mein Kaam (Examiner Answer) |
| :--- | :--- |
| **`ApiHandler.h`** | **HTTP & JSON Manager:** Incoming HTTP request se JSON code nikalta hai aur result ko JSON bana kar wapas bhejta hai. |
| **`QueueScheduler.h`** | **Queue & Thread Pool:** Submissions ki FIFO queue banata hai aur 3 worker threads mein divide karta hai taaki server hang na ho. |
| **`DockerSandbox.h`** | **Jail / OS Sandbox:** Code ko safe isolated Docker container mein chalata hai aur output/errors capture karta hai. |
| **`FileManager.h`** | **Disk Storage:** User ke code ko temporary file mein save karta hai aur run hone ke baad delete karta hai. |
| **`LanguageConfig.h`** | **Language Rulebook:** 4 languages (C, C++, Python, Java) ki Docker commands, file extensions aur images batata hai. |
| **`ResultEvaluator.h`** | **Judge / Decision Maker:** Output aur exit code dekh kar verdict deta hai (*Accepted, TLE, MLE, Compilation Error, Runtime Error*). |
| **`httplib.h`** | **Mini Web Server:** C++ library jo port 8080 par `/run` aur `/health` routes listen karti hai. |

---

## ⚙️ PART 2: C++ Standard Library Headers
*(Agar teacher ne puch liya: "Yeh kyu include kiya hai?")*

| Standard Header | Teacher ko kya bolna hai? |
| :--- | :--- |
| `<iostream>` | Console par printing aur logs ke liye (`cout`, `cerr`). |
| `<string>` | User code, language name aur output text store karne ke liye. |
| `<vector>` | Worker threads ki list (`vector<thread>`) store karne ke liye. |
| `<queue>` | Submissions ko First-In-First-Out (FIFO) line mein lagane ke liye. |
| `<memory>` | Smart pointers (`shared_ptr`) ke liye taaki **memory leak na ho**. |
| `<mutex>` | **Data Race rokne ke liye** — do threads ek saath same queue ya counter ko corrupt na karein. |
| `<condition_variable>` | Worker threads ko **sleep** par rakhne aur naya task aane par **wake up** (`notify`) karne ke liye. |
| `<thread>` | Multi-threading ke liye (3 parallel workers). |
| `<atomic>` | Lock-free counters (`fileCounter`, `taskCounter`) ko thread-safe banane ke liye. |
| `<chrono>` | 15-second HTTP request timeout aur timestamp generation ke liye. |
| `<fstream>` | Hard disk par temporary files write (`ofstream`) aur read (`ifstream`) karne ke liye. |
| `<sstream>` | Strings ko easily concatenate karke JSON ya file content banane ke liye (`stringstream`). |
| `<algorithm>` | String ko lowercase mein convert karne ke liye (`transform`). |
| `<cctype>` | Characters check karne ke liye (`tolower`, `isalnum`, `isspace`). |
| `<csignal>` | **Ctrl+C (`SIGINT`)** dabane par server ko crash hone ke bajaye clean shutdown karne ke liye. |
| `<cstdio>` | Disk se files delete karne ke liye (`remove()`) aur format karne ke liye. |

---

## 🐧 PART 3: Low-Level OS Headers (Systems Programming Special)
*(Yeh bol diya toh teacher full marks de dega!)*

| OS Header | Teacher ko kya bolna hai? |
| :--- | :--- |
| `<unistd.h>` *(Linux)* / `<process.h>` *(Windows)* | Current process ki **Process ID (`getpid()`)** lene ke liye taaki temp files ka unique naam ban sake. |
| `<sys/wait.h>` *(Linux)* | Child process ka exit status aur system signals (jaise **SIGKILL (137)** for Memory Limit) decode karne ke liye. |
| `<sys/stat.h>` *(Linux)* / `<direct.h>` *(Windows)* | Java classes ke liye unique temporary folders create (`mkdir`) aur remove (`rmdir`) karne ke liye. |

---

## 🎯 Viva Master Formula (3 Golden Rules)
1. **Concurrency / Multi-threading:** `<thread>`, `<mutex>`, `<condition_variable>`, `<atomic>`
2. **File Handling & Cleanup:** `<fstream>`, `<cstdio>`, `FileManager.h`
3. **OS / Process Control:** `<sys/wait.h>`, `<unistd.h>`, `<csignal>`, `DockerSandbox.h`
