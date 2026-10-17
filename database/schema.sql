-- =============================================================================
-- CodeBox: Database Schema (WORK IN PROGRESS - DRAFT 1)
-- Level: Initial 1NF Draft (First Normal Form)
-- Note: Currently designing basic tables. Normalization to 2NF/3NF and 
--       foreign key constraints will be completed in the next phase.
-- =============================================================================

-- Table 1: Basic Users
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 2: Problems (1NF Draft - inputs/outputs stored directly with problem)
-- TO DO: Split test cases into a separate table in Phase 3 for 2NF/3NF normalization
CREATE TABLE problems (
    problem_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    difficulty VARCHAR(20) DEFAULT 'Easy',
    sample_input TEXT,
    sample_output TEXT,
    time_limit_sec INT DEFAULT 2
);

-- Table 3: Raw Submissions Log
-- TO DO: Add Foreign Key constraints and indexing (user_id, problem_id)
CREATE TABLE submissions (
    submission_id SERIAL PRIMARY KEY,
    user_id INT,
    problem_id INT,
    language VARCHAR(20),
    code TEXT,
    status VARCHAR(30) DEFAULT 'Pending',
    execution_time_ms INT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------------------------------
-- Sample Test Data (For manual testing in pg Admin)
-- -----------------------------------------------------------------------------
INSERT INTO users (username, email, password) VALUES 
('ayush', 'ayush@example.com', 'pass123'),
('student1', 'student1@example.com', 'pass123');

INSERT INTO problems (title, description, difficulty, sample_input, sample_output) VALUES 
('Array Sorting', 'Sort the given space-separated numbers in ascending order', 'Easy', '40 10 80 20', '10 20 40 80'),
('Two Sum', 'Find two indices that sum to the target value', 'Easy', '2 7 11 15\n9', '0 1');
