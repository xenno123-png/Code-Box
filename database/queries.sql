-- =============================================================================
-- CodeBox: Production 3NF Relational Database Queries (SQLite3)
-- All queries strictly adhere to 3rd Normal Form with zero transitive dependencies.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. USER AUTHENTICATION & MANAGEMENT
-- -----------------------------------------------------------------------------

-- 1.1 Register New User
INSERT INTO users (username, email, password_hash)
VALUES (:username, :email, :password_hash);

-- 1.2 Authenticate / Login User (by Username or Email)
SELECT user_id, username, email, password_hash, created_at
FROM users
WHERE username = :identifier OR email = :identifier
LIMIT 1;

-- 1.3 Check if Username or Email Already Exists
SELECT user_id FROM users
WHERE username = :username OR email = :email
LIMIT 1;

-- -----------------------------------------------------------------------------
-- 2. PROBLEM RETRIEVAL & FILTERING (WITH 3NF JOINS)
-- -----------------------------------------------------------------------------

-- 2.1 Fetch All Problems for Catalog with Difficulty, Category & User Solved Status
SELECT 
    p.problem_id,
    p.title,
    p.slug,
    d.label AS difficulty,
    d.points,
    c.name AS category,
    EXISTS (
        SELECT 1 FROM submissions s 
        WHERE s.problem_id = p.problem_id 
          AND s.user_id = :user_id 
          AND s.verdict = 'Accepted'
    ) AS is_solved
FROM problems p
JOIN difficulties d ON p.difficulty_id = d.difficulty_id
JOIN categories c ON p.category_id = c.category_id
ORDER BY p.problem_id ASC;

-- 2.2 Fetch Single Problem Detail (Full Statement, Starter Codes & Sample Test Cases)
SELECT 
    p.problem_id,
    p.title,
    p.slug,
    p.description,
    p.constraints,
    d.label AS difficulty,
    d.points,
    c.name AS category,
    p.starter_cpp,
    p.starter_python,
    p.starter_java
FROM problems p
JOIN difficulties d ON p.difficulty_id = d.difficulty_id
JOIN categories c ON p.category_id = c.category_id
WHERE p.problem_id = :problem_id
LIMIT 1;

-- 2.3 Fetch Visible Sample Test Cases for a Problem (For Editor Run / Testing)
SELECT testcase_id, input_data, expected_output, is_sample
FROM test_cases
WHERE problem_id = :problem_id AND is_sample = 1
ORDER BY testcase_id ASC;

-- 2.4 Fetch All Test Cases (Sample + Hidden) for Submission Judging
SELECT testcase_id, input_data, expected_output, is_sample
FROM test_cases
WHERE problem_id = :problem_id
ORDER BY is_sample DESC, testcase_id ASC;

-- -----------------------------------------------------------------------------
-- 3. SUBMISSION MANAGEMENT & LOGGING
-- -----------------------------------------------------------------------------

-- 3.1 Record a Code Submission
INSERT INTO submissions (
    user_id,
    problem_id,
    language_id,
    source_code,
    verdict,
    execution_time_ms,
    memory_used_kb,
    passed_cases,
    total_cases
) VALUES (
    :user_id,
    :problem_id,
    (SELECT language_id FROM languages WHERE name = :language_name),
    :source_code,
    :verdict,
    :execution_time_ms,
    :memory_used_kb,
    :passed_cases,
    :total_cases
);

-- 3.2 Fetch Recent Submissions for a Specific User
SELECT 
    s.submission_id,
    p.problem_id,
    p.title AS problem_title,
    d.label AS difficulty,
    l.display_name AS language,
    s.verdict,
    s.execution_time_ms,
    s.memory_used_kb,
    s.passed_cases,
    s.total_cases,
    s.submitted_at
FROM submissions s
JOIN problems p ON s.problem_id = p.problem_id
JOIN difficulties d ON p.difficulty_id = d.difficulty_id
JOIN languages l ON s.language_id = l.language_id
WHERE s.user_id = :user_id
ORDER BY s.submitted_at DESC
LIMIT :limit;

-- -----------------------------------------------------------------------------
-- 4. USER STATS & LEADERBOARD (STRICT 3NF AGGREGATIONS)
-- -----------------------------------------------------------------------------

-- 4.1 User Solved Problems Breakdown & Total Score
SELECT 
    u.user_id,
    u.username,
    u.email,
    u.created_at,
    COUNT(DISTINCT CASE WHEN s.verdict = 'Accepted' AND d.label = 'Easy' THEN s.problem_id END) AS solved_easy,
    COUNT(DISTINCT CASE WHEN s.verdict = 'Accepted' AND d.label = 'Medium' THEN s.problem_id END) AS solved_medium,
    COUNT(DISTINCT CASE WHEN s.verdict = 'Accepted' AND d.label = 'Hard' THEN s.problem_id END) AS solved_hard,
    COUNT(DISTINCT CASE WHEN s.verdict = 'Accepted' THEN s.problem_id END) AS total_solved,
    COALESCE((
        SELECT SUM(d2.points)
        FROM (
            SELECT DISTINCT s2.problem_id
            FROM submissions s2
            WHERE s2.user_id = u.user_id AND s2.verdict = 'Accepted'
        ) solved
        JOIN problems p2 ON solved.problem_id = p2.problem_id
        JOIN difficulties d2 ON p2.difficulty_id = d2.difficulty_id
    ), 0) AS total_score,
    COUNT(s.submission_id) AS total_submissions
FROM users u
LEFT JOIN submissions s ON u.user_id = s.user_id
LEFT JOIN problems p ON s.problem_id = p.problem_id
LEFT JOIN difficulties d ON p.difficulty_id = d.difficulty_id
WHERE u.user_id = :user_id
GROUP BY u.user_id, u.username, u.email, u.created_at;

-- 4.2 Global Ranked Leaderboard
-- Ranks users by Total Points from distinct solved problems, then solved count, then earliest registration
SELECT 
    u.user_id,
    u.username,
    COALESCE(SUM(DISTINCT CASE WHEN s.verdict = 'Accepted' THEN d.points ELSE 0 END), 0) AS total_score,
    COUNT(DISTINCT CASE WHEN s.verdict = 'Accepted' THEN s.problem_id END) AS solved_count,
    COUNT(s.submission_id) AS total_submissions,
    u.created_at
FROM users u
LEFT JOIN submissions s ON u.user_id = s.user_id
LEFT JOIN problems p ON s.problem_id = p.problem_id
LEFT JOIN difficulties d ON p.difficulty_id = d.difficulty_id
GROUP BY u.user_id, u.username, u.created_at
ORDER BY total_score DESC, solved_count DESC, u.created_at ASC
LIMIT :limit;
