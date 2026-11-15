# CodeBox - Database Module (Phase 3 Strict 3NF Relational Model)

**Status:** Completed & Production-Grade  
**Database Engine:** SQLite3 (`codebox.db`) with WAL Mode & Enforced Foreign Keys  
**Design Standard:** Strict 3rd Normal Form (3NF) — Zero Transitive Dependencies

---

## 🗄️ Relational Schema (3NF Architecture)

The database schema is partitioned into 7 normalized tables to eliminate data redundancy and ensure referential integrity:

1. **`users`**:
   - `user_id` (PK, AUTOINCREMENT)
   - `username` (UNIQUE, NOCASE)
   - `email` (UNIQUE, NOCASE)
   - `password_hash` (TEXT)
   - `created_at` (DATETIME)

2. **`difficulties`** *(Lookup Table)*:
   - `difficulty_id` (PK)
   - `label` (UNIQUE: 'Easy', 'Medium', 'Hard')
   - `points` (10, 20, 30 — points depend exclusively on difficulty)

3. **`categories`** *(Lookup Table)*:
   - `category_id` (PK)
   - `name` (UNIQUE: 'Arrays', 'Strings', 'Hashing', 'Two Pointers', 'Binary Search', 'Stack', 'Linked List', 'Dynamic Programming', 'Trees', 'Math')

4. **`languages`** *(Lookup Table)*:
   - `language_id` (PK)
   - `name` (UNIQUE: 'c', 'cpp', 'python', 'java')
   - `display_name` ('C (GCC)', 'C++17', 'Python 3', 'Java 17')
   - `docker_image` ('gcc:latest', 'python:3', 'openjdk:17')

5. **`problems`**:
   - `problem_id` (PK, AUTOINCREMENT)
   - `title`, `slug` (UNIQUE), `description`, `constraints`
   - `difficulty_id` (FK -> `difficulties.difficulty_id`)
   - `category_id` (FK -> `categories.category_id`)
   - `starter_c`, `starter_cpp`, `starter_python`, `starter_java`

6. **`test_cases`**:
   - `testcase_id` (PK, AUTOINCREMENT)
   - `problem_id` (FK -> `problems.problem_id` ON DELETE CASCADE)
   - `input_data`, `expected_output`
   - `is_sample` (1 = Sample/Public, 0 = Hidden)

7. **`submissions`**:
   - `submission_id` (PK, AUTOINCREMENT)
   - `user_id` (FK -> `users.user_id` ON DELETE CASCADE)
   - `problem_id` (FK -> `problems.problem_id` ON DELETE CASCADE)
   - `language_id` (FK -> `languages.language_id`)
   - `source_code`, `verdict`, `execution_time_ms`, `memory_used_kb`, `passed_cases`, `total_cases`, `submitted_at`

---

## ⚡ Performance Optimizations
- **Write-Ahead Logging (WAL)**: Enabled via `PRAGMA journal_mode = WAL;` to permit concurrent readers alongside active writers without lock contention.
- **Foreign Key Enforcement**: `PRAGMA foreign_keys = ON;` guarantees strict referential integrity.
- **Indexes**:
  - `idx_problems_difficulty` on `problems(difficulty_id)`
  - `idx_problems_category` on `problems(category_id)`
  - `idx_testcases_problem` on `test_cases(problem_id)`
  - `idx_submissions_user` on `submissions(user_id)`
  - `idx_submissions_verdict` on `submissions(verdict)`

---

## 📂 File Directory
- **`schema.sql`**: Full DDL script creating all 7 3NF tables, foreign key constraints, and performance indexes.
- **`seed_problems.sql`**: Populates all lookup tables, 30 full DSA problems, starter templates for 4 languages, and sample & hidden test cases.
- **`queries.sql`**: Production SQL queries for user authentication, problem catalog queries with JOINs, submission verdicts, progress metrics, and leaderboard calculation.
- **`codebox.db`**: The SQLite3 database binary file.
