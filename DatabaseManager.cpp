#include "Headers.h"
#include <fstream>
#include <sstream>

DatabaseManager::DatabaseManager() : db(nullptr), dbFilePath("codebox.db") {}

DatabaseManager::~DatabaseManager() {
    close();
}

DatabaseManager& DatabaseManager::instance() {
    static DatabaseManager mgr;
    return mgr;
}

bool DatabaseManager::init(const string& dbPath) {
    lock_guard<mutex> lock(dbMtx);
    if (db) {
        return true;
    }

    dbFilePath = dbPath;
    int rc = sqlite3_open(dbPath.c_str(), &db);
    if (rc != SQLITE_OK) {
        cerr << "DatabaseManager: failed to open SQLite database " << dbPath 
             << " (" << sqlite3_errmsg(db) << ")" << endl;
        if (db) {
            sqlite3_close(db);
            db = nullptr;
        }
        return false;
    }

    // Set pragmas for performance, foreign keys, and concurrency timeout
    sqlite3_exec(db, "PRAGMA foreign_keys = ON;", nullptr, nullptr, nullptr);
    sqlite3_exec(db, "PRAGMA journal_mode = WAL;", nullptr, nullptr, nullptr);
    sqlite3_exec(db, "PRAGMA busy_timeout = 5000;", nullptr, nullptr, nullptr);

    cout << "DatabaseManager: SQLite database initialized at " << dbPath << endl;
    return true;
}

void DatabaseManager::close() {
    lock_guard<mutex> lock(dbMtx);
    if (db) {
        sqlite3_close(db);
        db = nullptr;
    }
}

bool DatabaseManager::autoInitialize(const string& schemaPath, const string& seedPath) {
    if (!db) {
        if (!init(dbFilePath)) return false;
    }

    bool needsInit = false;
    {
        lock_guard<mutex> lock(dbMtx);
        const char* checkSql = "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='problems';";
        sqlite3_stmt* stmt = nullptr;
        if (sqlite3_prepare_v2(db, checkSql, -1, &stmt, nullptr) == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                int count = sqlite3_column_int(stmt, 0);
                if (count == 0) {
                    needsInit = true;
                }
            }
            sqlite3_finalize(stmt);
        } else {
            needsInit = true;
        }
    }

    if (needsInit) {
        cout << "DatabaseManager: tables not found. Initializing 3NF schema & seed problems..." << endl;
        if (!executeScript(schemaPath)) {
            cerr << "DatabaseManager: failed to execute schema script: " << schemaPath << endl;
            return false;
        }
        if (!executeScript(seedPath)) {
            cerr << "DatabaseManager: failed to execute seed script: " << seedPath << endl;
            return false;
        }
        cout << "DatabaseManager: 3NF database schema & 30 DSA problems seeded successfully!" << endl;
    } else {
        cout << "DatabaseManager: 3NF database schema and problems already exist." << endl;
        lock_guard<mutex> lock(dbMtx);
        sqlite3_exec(db, "ALTER TABLE problems ADD COLUMN starter_c TEXT NOT NULL DEFAULT '';", nullptr, nullptr, nullptr);
        sqlite3_exec(db, "INSERT OR IGNORE INTO languages (language_id, name, display_name, docker_image) VALUES (4, 'c', 'C (GCC)', 'gcc:latest');", nullptr, nullptr, nullptr);
    }

    return true;
}

bool DatabaseManager::executeScript(const string& scriptPath) {
    ifstream file(scriptPath);
    if (!file.is_open()) {
        cerr << "DatabaseManager: could not open script file " << scriptPath << endl;
        return false;
    }

    stringstream buffer;
    buffer << file.rdbuf();
    string sql = buffer.str();
    file.close();

    lock_guard<mutex> lock(dbMtx);
    if (!db) return false;

    char* errMsg = nullptr;
    int rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &errMsg);
    if (rc != SQLITE_OK) {
        cerr << "DatabaseManager: SQL script execution error in " << scriptPath << ": " 
             << (errMsg ? errMsg : "unknown") << endl;
        sqlite3_free(errMsg);
        return false;
    }
    return true;
}

bool DatabaseManager::registerUser(const string& username, const string& email, const string& password, 
                                  int& outUserId, string& outError) {
    lock_guard<mutex> lock(dbMtx);
    if (!db) { outError = "Database not connected"; return false; }

    // Check if username or email already exists
    const char* checkSql = "SELECT user_id FROM users WHERE username = ? OR email = ? LIMIT 1;";
    sqlite3_stmt* checkStmt = nullptr;
    if (sqlite3_prepare_v2(db, checkSql, -1, &checkStmt, nullptr) == SQLITE_OK) {
        sqlite3_bind_text(checkStmt, 1, username.c_str(), -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(checkStmt, 2, email.c_str(), -1, SQLITE_TRANSIENT);
        if (sqlite3_step(checkStmt) == SQLITE_ROW) {
            sqlite3_finalize(checkStmt);
            outError = "Username or Email already registered.";
            return false;
        }
        sqlite3_finalize(checkStmt);
    }

    const char* insertSql = "INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?);";
    sqlite3_stmt* stmt = nullptr;
    if (sqlite3_prepare_v2(db, insertSql, -1, &stmt, nullptr) != SQLITE_OK) {
        outError = sqlite3_errmsg(db);
        return false;
    }

    sqlite3_bind_text(stmt, 1, username.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, email.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, password.c_str(), -1, SQLITE_TRANSIENT);

    int rc = sqlite3_step(stmt);
    sqlite3_finalize(stmt);

    if (rc != SQLITE_DONE) {
        outError = sqlite3_errmsg(db);
        return false;
    }

    outUserId = static_cast<int>(sqlite3_last_insert_rowid(db));
    return true;
}

bool DatabaseManager::loginUser(const string& identifier, const string& password, 
                               int& outUserId, string& outUsername, string& outEmail, string& outError) {
    lock_guard<mutex> lock(dbMtx);
    if (!db) { outError = "Database not connected"; return false; }

    const char* sql = "SELECT user_id, username, email, password_hash FROM users WHERE username = ? OR email = ? LIMIT 1;";
    sqlite3_stmt* stmt = nullptr;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, nullptr) != SQLITE_OK) {
        outError = sqlite3_errmsg(db);
        return false;
    }

    sqlite3_bind_text(stmt, 1, identifier.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, identifier.c_str(), -1, SQLITE_TRANSIENT);

    int rc = sqlite3_step(stmt);
    if (rc != SQLITE_ROW) {
        sqlite3_finalize(stmt);
        outError = "Invalid username or password.";
        return false;
    }

    outUserId = sqlite3_column_int(stmt, 0);
    outUsername = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 1));
    outEmail = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 2));
    string storedHash = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 3));
    sqlite3_finalize(stmt);

    if (storedHash != password) {
        outError = "Invalid username or password.";
        return false;
    }

    return true;
}

string DatabaseManager::getUserStatsJson(int userId) {
    lock_guard<mutex> lock(dbMtx);
    if (!db) return "{}";

    const char* sql = 
        "SELECT "
        "  COUNT(DISTINCT CASE WHEN s.verdict = 'Accepted' AND d.label = 'Easy' THEN s.problem_id END) AS solved_easy, "
        "  COUNT(DISTINCT CASE WHEN s.verdict = 'Accepted' AND d.label = 'Medium' THEN s.problem_id END) AS solved_medium, "
        "  COUNT(DISTINCT CASE WHEN s.verdict = 'Accepted' AND d.label = 'Hard' THEN s.problem_id END) AS solved_hard, "
        "  COUNT(DISTINCT CASE WHEN s.verdict = 'Accepted' THEN s.problem_id END) AS total_solved, "
        "  COALESCE(( "
        "    SELECT SUM(d2.points) "
        "    FROM (SELECT DISTINCT s2.problem_id FROM submissions s2 WHERE s2.user_id = ? AND s2.verdict = 'Accepted') solved "
        "    JOIN problems p2 ON solved.problem_id = p2.problem_id "
        "    JOIN difficulties d2 ON p2.difficulty_id = d2.difficulty_id "
        "  ), 0) AS total_score, "
        "  (SELECT COUNT(*) FROM submissions WHERE user_id = ?) AS total_submissions "
        "FROM users u "
        "LEFT JOIN submissions s ON u.user_id = s.user_id "
        "LEFT JOIN problems p ON s.problem_id = p.problem_id "
        "LEFT JOIN difficulties d ON p.difficulty_id = d.difficulty_id "
        "WHERE u.user_id = ? "
        "GROUP BY u.user_id;";

    sqlite3_stmt* stmt = nullptr;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, nullptr) != SQLITE_OK) {
        return "{}";
    }

    sqlite3_bind_int(stmt, 1, userId);
    sqlite3_bind_int(stmt, 2, userId);
    sqlite3_bind_int(stmt, 3, userId);

    stringstream ss;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        int easy = sqlite3_column_int(stmt, 0);
        int medium = sqlite3_column_int(stmt, 1);
        int hard = sqlite3_column_int(stmt, 2);
        int totalSolved = sqlite3_column_int(stmt, 3);
        int totalScore = sqlite3_column_int(stmt, 4);
        int totalSubmissions = sqlite3_column_int(stmt, 5);

        ss << "{"
           << "\"solved_easy\":" << easy << ","
           << "\"solved_medium\":" << medium << ","
           << "\"solved_hard\":" << hard << ","
           << "\"total_solved\":" << totalSolved << ","
           << "\"total_score\":" << totalScore << ","
           << "\"total_submissions\":" << totalSubmissions
           << "}";
    } else {
        ss << "{\"solved_easy\":0,\"solved_medium\":0,\"solved_hard\":0,\"total_solved\":0,\"total_score\":0,\"total_submissions\":0}";
    }
    sqlite3_finalize(stmt);
    return ss.str();
}

string DatabaseManager::getProblemsJson(int userId) {
    lock_guard<mutex> lock(dbMtx);
    if (!db) return "[]";

    const char* sql = 
        "SELECT "
        "  p.problem_id, "
        "  p.title, "
        "  p.slug, "
        "  d.label AS difficulty, "
        "  d.points, "
        "  c.name AS category, "
        "  EXISTS ( "
        "    SELECT 1 FROM submissions s "
        "    WHERE s.problem_id = p.problem_id "
        "      AND s.user_id = ? "
        "      AND s.verdict = 'Accepted' "
        "  ) AS is_solved "
        "FROM problems p "
        "JOIN difficulties d ON p.difficulty_id = d.difficulty_id "
        "JOIN categories c ON p.category_id = c.category_id "
        "ORDER BY p.problem_id ASC;";

    sqlite3_stmt* stmt = nullptr;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, nullptr) != SQLITE_OK) {
        return "[]";
    }

    sqlite3_bind_int(stmt, 1, userId);

    stringstream ss;
    ss << "[";
    bool first = true;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        if (!first) ss << ",";
        first = false;

        int problemId = sqlite3_column_int(stmt, 0);
        string title = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 1));
        string slug = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 2));
        string difficulty = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 3));
        int points = sqlite3_column_int(stmt, 4);
        string category = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 5));
        bool isSolved = sqlite3_column_int(stmt, 6) != 0;

        ss << "{"
           << "\"problem_id\":" << problemId << ","
           << "\"title\":\"" << escapeJson(title) << "\","
           << "\"slug\":\"" << escapeJson(slug) << "\","
           << "\"difficulty\":\"" << escapeJson(difficulty) << "\","
           << "\"points\":" << points << ","
           << "\"category\":\"" << escapeJson(category) << "\","
           << "\"is_solved\":" << (isSolved ? "true" : "false")
           << "}";
    }
    sqlite3_finalize(stmt);
    ss << "]";
    return ss.str();
}

string DatabaseManager::getProblemDetailJson(int problemId) {
    lock_guard<mutex> lock(dbMtx);
    if (!db) return "{}";

    const char* sql = 
        "SELECT "
        "  p.problem_id, p.title, p.slug, p.description, p.constraints, "
        "  d.label, d.points, c.name, "
        "  p.starter_cpp, p.starter_python, p.starter_java, p.starter_c "
        "FROM problems p "
        "JOIN difficulties d ON p.difficulty_id = d.difficulty_id "
        "JOIN categories c ON p.category_id = c.category_id "
        "WHERE p.problem_id = ? "
        "LIMIT 1;";

    sqlite3_stmt* stmt = nullptr;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, nullptr) != SQLITE_OK) {
        return "{}";
    }

    sqlite3_bind_int(stmt, 1, problemId);

    if (sqlite3_step(stmt) != SQLITE_ROW) {
        sqlite3_finalize(stmt);
        return "{}";
    }

    int id = sqlite3_column_int(stmt, 0);
    string title = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 1));
    string slug = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 2));
    string desc = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 3));
    string constraints = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 4));
    string diff = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 5));
    int points = sqlite3_column_int(stmt, 6);
    string cat = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 7));
    string starterCpp = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 8));
    string starterPy = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 9));
    string starterJava = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 10));
    string starterC = sqlite3_column_text(stmt, 11) ? reinterpret_cast<const char*>(sqlite3_column_text(stmt, 11)) : "";
    sqlite3_finalize(stmt);

    // Fetch sample test cases
    const char* tcSql = "SELECT testcase_id, input_data, expected_output FROM test_cases WHERE problem_id = ? AND is_sample = 1 ORDER BY testcase_id ASC;";
    sqlite3_stmt* tcStmt = nullptr;
    stringstream sampleTcJson;
    sampleTcJson << "[";
    if (sqlite3_prepare_v2(db, tcSql, -1, &tcStmt, nullptr) == SQLITE_OK) {
        sqlite3_bind_int(tcStmt, 1, problemId);
        bool firstTc = true;
        while (sqlite3_step(tcStmt) == SQLITE_ROW) {
            if (!firstTc) sampleTcJson << ",";
            firstTc = false;
            int tcId = sqlite3_column_int(tcStmt, 0);
            string inData = reinterpret_cast<const char*>(sqlite3_column_text(tcStmt, 1));
            string outData = reinterpret_cast<const char*>(sqlite3_column_text(tcStmt, 2));
            sampleTcJson << "{"
                         << "\"testcase_id\":" << tcId << ","
                         << "\"input\":\"" << escapeJson(inData) << "\","
                         << "\"expected_output\":\"" << escapeJson(outData) << "\""
                         << "}";
        }
        sqlite3_finalize(tcStmt);
    }
    sampleTcJson << "]";

    stringstream ss;
    ss << "{"
       << "\"problem_id\":" << id << ","
       << "\"title\":\"" << escapeJson(title) << "\","
       << "\"slug\":\"" << escapeJson(slug) << "\","
       << "\"description\":\"" << escapeJson(desc) << "\","
       << "\"constraints\":\"" << escapeJson(constraints) << "\","
       << "\"difficulty\":\"" << escapeJson(diff) << "\","
       << "\"points\":" << points << ","
       << "\"category\":\"" << escapeJson(cat) << "\","
       << "\"starter_cpp\":\"" << escapeJson(starterCpp) << "\","
       << "\"starter_python\":\"" << escapeJson(starterPy) << "\","
       << "\"starter_java\":\"" << escapeJson(starterJava) << "\","
       << "\"starter_c\":\"" << escapeJson(starterC) << "\","
       << "\"sample_test_cases\":" << sampleTcJson.str() << ","
       << "\"sample_testcases\":" << sampleTcJson.str()
       << "}";

    return ss.str();
}

vector<DatabaseManager::TestCaseInfo> DatabaseManager::getTestCases(int problemId, bool sampleOnly) {
    lock_guard<mutex> lock(dbMtx);
    vector<TestCaseInfo> list;
    if (!db) return list;

    string sql = "SELECT testcase_id, problem_id, input_data, expected_output, is_sample FROM test_cases WHERE problem_id = ?";
    if (sampleOnly) {
        sql += " AND is_sample = 1";
    }
    sql += " ORDER BY is_sample DESC, testcase_id ASC;";

    sqlite3_stmt* stmt = nullptr;
    if (sqlite3_prepare_v2(db, sql.c_str(), -1, &stmt, nullptr) != SQLITE_OK) {
        return list;
    }

    sqlite3_bind_int(stmt, 1, problemId);
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        TestCaseInfo tc;
        tc.id = sqlite3_column_int(stmt, 0);
        tc.problemId = sqlite3_column_int(stmt, 1);
        tc.input = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 2));
        tc.expectedOutput = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 3));
        tc.isSample = sqlite3_column_int(stmt, 4) != 0;
        list.push_back(tc);
    }
    sqlite3_finalize(stmt);
    return list;
}

int DatabaseManager::getLanguageId(const string& langName) {
    const char* sql = "SELECT language_id FROM languages WHERE name = ? LIMIT 1;";
    sqlite3_stmt* stmt = nullptr;
    int langId = 1; // default cpp
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, nullptr) == SQLITE_OK) {
        string l = langName;
        if (l == "c++") l = "cpp";
        if (l == "py") l = "python";
        sqlite3_bind_text(stmt, 1, l.c_str(), -1, SQLITE_TRANSIENT);
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            langId = sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }
    return langId;
}

int DatabaseManager::recordSubmission(int userId, int problemId, const string& language, const string& sourceCode, 
                                     const string& verdict, int executionTimeMs, int memoryUsedKb, 
                                     int passedCases, int totalCases) {
    lock_guard<mutex> lock(dbMtx);
    if (!db) return -1;

    int langId = getLanguageId(language);

    const char* sql = 
        "INSERT INTO submissions (user_id, problem_id, language_id, source_code, verdict, "
        "execution_time_ms, memory_used_kb, passed_cases, total_cases) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);";

    sqlite3_stmt* stmt = nullptr;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, nullptr) != SQLITE_OK) {
        return -1;
    }

    sqlite3_bind_int(stmt, 1, userId);
    sqlite3_bind_int(stmt, 2, problemId);
    sqlite3_bind_int(stmt, 3, langId);
    sqlite3_bind_text(stmt, 4, sourceCode.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 5, verdict.c_str(), -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(stmt, 6, executionTimeMs);
    sqlite3_bind_int(stmt, 7, memoryUsedKb);
    sqlite3_bind_int(stmt, 8, passedCases);
    sqlite3_bind_int(stmt, 9, totalCases);

    int rc = sqlite3_step(stmt);
    sqlite3_finalize(stmt);

    if (rc != SQLITE_DONE) return -1;
    return static_cast<int>(sqlite3_last_insert_rowid(db));
}

string DatabaseManager::getUserSubmissionsJson(int userId, int limit) {
    lock_guard<mutex> lock(dbMtx);
    if (!db) return "[]";

    const char* sql = 
        "SELECT "
        "  s.submission_id, "
        "  p.problem_id, "
        "  p.title AS problem_title, "
        "  d.label AS difficulty, "
        "  l.display_name AS language, "
        "  s.verdict, "
        "  s.execution_time_ms, "
        "  s.memory_used_kb, "
        "  s.passed_cases, "
        "  s.total_cases, "
        "  s.submitted_at "
        "FROM submissions s "
        "JOIN problems p ON s.problem_id = p.problem_id "
        "JOIN difficulties d ON p.difficulty_id = d.difficulty_id "
        "JOIN languages l ON s.language_id = l.language_id "
        "WHERE s.user_id = ? "
        "ORDER BY s.submitted_at DESC "
        "LIMIT ?;";

    sqlite3_stmt* stmt = nullptr;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, nullptr) != SQLITE_OK) {
        return "[]";
    }

    sqlite3_bind_int(stmt, 1, userId);
    sqlite3_bind_int(stmt, 2, limit);

    stringstream ss;
    ss << "[";
    bool first = true;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        if (!first) ss << ",";
        first = false;

        int subId = sqlite3_column_int(stmt, 0);
        int probId = sqlite3_column_int(stmt, 1);
        string title = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 2));
        string diff = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 3));
        string lang = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 4));
        string verdict = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 5));
        int timeMs = sqlite3_column_int(stmt, 6);
        int memKb = sqlite3_column_int(stmt, 7);
        int passed = sqlite3_column_int(stmt, 8);
        int total = sqlite3_column_int(stmt, 9);
        string submittedAt = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 10));

        ss << "{"
           << "\"submission_id\":" << subId << ","
           << "\"problem_id\":" << probId << ","
           << "\"problem_title\":\"" << escapeJson(title) << "\","
           << "\"difficulty\":\"" << escapeJson(diff) << "\","
           << "\"language\":\"" << escapeJson(lang) << "\","
           << "\"verdict\":\"" << escapeJson(verdict) << "\","
           << "\"execution_time_ms\":" << timeMs << ","
           << "\"memory_used_kb\":" << memKb << ","
           << "\"passed_cases\":" << passed << ","
           << "\"total_cases\":" << total << ","
           << "\"submitted_at\":\"" << escapeJson(submittedAt) << "\""
           << "}";
    }
    sqlite3_finalize(stmt);
    ss << "]";
    return ss.str();
}

string DatabaseManager::getLeaderboardJson(int limit) {
    lock_guard<mutex> lock(dbMtx);
    if (!db) return "[]";

    const char* sql = 
        "SELECT "
        "  u.user_id, "
        "  u.username, "
        "  COALESCE(SUM(DISTINCT CASE WHEN s.verdict = 'Accepted' THEN d.points ELSE 0 END), 0) AS total_score, "
        "  COUNT(DISTINCT CASE WHEN s.verdict = 'Accepted' THEN s.problem_id END) AS solved_count, "
        "  COUNT(s.submission_id) AS total_submissions, "
        "  u.created_at "
        "FROM users u "
        "LEFT JOIN submissions s ON u.user_id = s.user_id "
        "LEFT JOIN problems p ON s.problem_id = p.problem_id "
        "LEFT JOIN difficulties d ON p.difficulty_id = d.difficulty_id "
        "GROUP BY u.user_id, u.username, u.created_at "
        "ORDER BY total_score DESC, solved_count DESC, u.created_at ASC "
        "LIMIT ?;";

    sqlite3_stmt* stmt = nullptr;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, nullptr) != SQLITE_OK) {
        return "[]";
    }

    sqlite3_bind_int(stmt, 1, limit);

    stringstream ss;
    ss << "[";
    bool first = true;
    int rank = 1;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        if (!first) ss << ",";
        first = false;

        int userId = sqlite3_column_int(stmt, 0);
        string username = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 1));
        int score = sqlite3_column_int(stmt, 2);
        int solved = sqlite3_column_int(stmt, 3);
        int totalSub = sqlite3_column_int(stmt, 4);
        string createdAt = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 5));

        ss << "{"
           << "\"rank\":" << rank++ << ","
           << "\"user_id\":" << userId << ","
           << "\"username\":\"" << escapeJson(username) << "\","
           << "\"total_score\":" << score << ","
           << "\"solved_count\":" << solved << ","
           << "\"total_submissions\":" << totalSub << ","
           << "\"created_at\":\"" << escapeJson(createdAt) << "\""
           << "}";
    }
    sqlite3_finalize(stmt);
    ss << "]";
    return ss.str();
}

string DatabaseManager::escapeJson(const string& s) {
    string out;
    out.reserve(s.size() + 32);
    for (char c : s) {
        switch (c) {
            case '"':  out += "\\\""; break;
            case '\\': out += "\\\\"; break;
            case '\b': out += "\\b"; break;
            case '\f': out += "\\f"; break;
            case '\n': out += "\\n"; break;
            case '\r': out += "\\r"; break;
            case '\t': out += "\\t"; break;
            default:
                if (static_cast<unsigned char>(c) < 0x20) {
                    char buf[8];
                    snprintf(buf, sizeof(buf), "\\u%04x", static_cast<unsigned char>(c));
                    out += buf;
                } else {
                    out += c;
                }
                break;
        }
    }
    return out;
}
