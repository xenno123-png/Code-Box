-- =============================================================================
-- CodeBox: Draft SQL Queries (Testing in progress)
-- =============================================================================

-- 1. Insert a new submission from execution engine (Draft)
INSERT INTO submissions (user_id, problem_id, language, code, status, execution_time_ms)
VALUES (1, 1, 'cpp', '#include <iostream>...', 'Accepted', 45);

-- 2. Fetch all problems for display
SELECT problem_id, title, difficulty FROM problems;

-- 3. Fetch submissions history of a user
SELECT * FROM submissions WHERE user_id = 1 ORDER BY submitted_at DESC;

-- TODO for Phase 3:
-- - Add JOIN queries between Users, Problems and Submissions
-- - Add transaction blocks (BEGIN ... COMMIT)
-- - Add index query optimization
