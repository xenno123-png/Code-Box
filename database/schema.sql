-- =============================================================================
-- CodeBox: Database Schema (Phase 3 - Strict 3NF Relational Model)
-- Database Engine: SQLite3 (codebox.db)
-- Level: 3rd Normal Form (3NF) - Zero transitive dependencies
-- =============================================================================

PRAGMA foreign_keys = ON;

-- -----------------------------------------------------------------------------
-- 1. Users Table
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL COLLATE NOCASE,
    email TEXT UNIQUE NOT NULL COLLATE NOCASE,
    password_hash TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------------------------------
-- 2. Difficulties Lookup Table (Normalized 3NF - points depend solely on difficulty)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS difficulties (
    difficulty_id INTEGER PRIMARY KEY AUTOINCREMENT,
    label TEXT UNIQUE NOT NULL, -- 'Easy', 'Medium', 'Hard'
    points INTEGER NOT NULL
);

-- -----------------------------------------------------------------------------
-- 3. Categories Lookup Table (Normalized 3NF)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL
);

-- -----------------------------------------------------------------------------
-- 4. Languages Lookup Table (Normalized 3NF)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS languages (
    language_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,        -- 'cpp', 'python', 'java'
    display_name TEXT NOT NULL,       -- 'C++17', 'Python 3', 'Java 17'
    docker_image TEXT NOT NULL        -- 'gcc:latest', 'python:3', 'openjdk:17'
);

-- -----------------------------------------------------------------------------
-- 5. Problems Table (Strict 3NF: foreign keys to difficulties and categories)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS problems (
    problem_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT NOT NULL,
    constraints TEXT NOT NULL,
    difficulty_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    starter_cpp TEXT NOT NULL,
    starter_python TEXT NOT NULL,
    starter_java TEXT NOT NULL,
    FOREIGN KEY (difficulty_id) REFERENCES difficulties(difficulty_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- -----------------------------------------------------------------------------
-- 6. Test Cases Table (Normalized 1-to-N relation)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS test_cases (
    testcase_id INTEGER PRIMARY KEY AUTOINCREMENT,
    problem_id INTEGER NOT NULL,
    input_data TEXT NOT NULL,
    expected_output TEXT NOT NULL,
    is_sample INTEGER NOT NULL DEFAULT 0, -- 1 = sample (visible), 0 = hidden
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id) ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------
-- 7. Submissions Table (Normalized execution log)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS submissions (
    submission_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    problem_id INTEGER NOT NULL,
    language_id INTEGER NOT NULL,
    source_code TEXT NOT NULL,
    verdict TEXT NOT NULL,             -- 'Accepted', 'Wrong Answer', 'Time Limit Exceeded', etc.
    execution_time_ms INTEGER NOT NULL DEFAULT 0,
    memory_used_kb INTEGER NOT NULL DEFAULT 0,
    passed_cases INTEGER NOT NULL DEFAULT 0,
    total_cases INTEGER NOT NULL DEFAULT 0,
    submitted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id) ON DELETE CASCADE,
    FOREIGN KEY (language_id) REFERENCES languages(language_id)
);

-- -----------------------------------------------------------------------------
-- Performance Indexes for 3NF Queries
-- -----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_problems_difficulty ON problems(difficulty_id);
CREATE INDEX IF NOT EXISTS idx_problems_category ON problems(category_id);
CREATE INDEX IF NOT EXISTS idx_testcases_problem ON test_cases(problem_id);
CREATE INDEX IF NOT EXISTS idx_submissions_user ON submissions(user_id);
CREATE INDEX IF NOT EXISTS idx_submissions_problem ON submissions(problem_id);
CREATE INDEX IF NOT EXISTS idx_submissions_verdict ON submissions(verdict);
