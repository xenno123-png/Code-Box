#include "Headers.h"
#include <fstream>
#include <sstream>

ApiHandler::ApiHandler(QueueScheduler& sched) : scheduler(sched), taskCounter(0) {}

void ApiHandler::handle(const httplib::Request& req, httplib::Response& res) {
    res.set_header("Access-Control-Allow-Origin", "*");
    res.set_header("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
    res.set_header("Access-Control-Allow-Headers", "Content-Type");

    if (req.method == "OPTIONS") {
        res.status = 200;
        return;
    }

    const string& path = req.path;

    // Frontend Web Asset
    if (path == "/" || path == "/index.html" || path == "/demo.html") {
        handleServeFrontend(res);
        return;
    }

    // Health check
    if (path == "/health") {
        sendJsonResponse(res, 200, "{\"status\":\"ok\"}");
        return;
    }

    // Auth endpoints
    if (path == "/api/register" && req.method == "POST") {
        handleRegister(req.body, res);
        return;
    }
    if (path == "/api/login" && req.method == "POST") {
        handleLogin(req.body, res);
        return;
    }

    // Problem Catalog endpoints
    if (path == "/api/problems" && req.method == "GET") {
        handleGetProblems(req, res);
        return;
    }
    if (path.rfind("/api/problems/", 0) == 0 && req.method == "GET") {
        string idStr = path.substr(14);
        try {
            int problemId = stoi(idStr);
            handleGetProblemDetail(problemId, res);
        } catch (...) {
            sendJsonResponse(res, 400, "{\"error\":\"Invalid problem ID format\"}");
        }
        return;
    }

    // Execution endpoints
    if (path == "/api/playground/run" && req.method == "POST") {
        handlePlaygroundRun(req.body, res);
        return;
    }
    if (path == "/api/leetcode/submit" && req.method == "POST") {
        handleLeetCodeSubmit(req.body, res);
        return;
    }

    // Leaderboard endpoint
    if (path == "/api/leaderboard" && req.method == "GET") {
        handleGetLeaderboard(res);
        return;
    }

    // User Submissions endpoint: /api/user/:id/submissions
    if (path.rfind("/api/user/", 0) == 0 && path.find("/submissions") != string::npos && req.method == "GET") {
        size_t start = 10; // length of "/api/user/"
        size_t end = path.find("/submissions", start);
        if (end != string::npos) {
            string idStr = path.substr(start, end - start);
            try {
                int userId = stoi(idStr);
                handleGetUserSubmissions(userId, res);
                return;
            } catch (...) {
                sendJsonResponse(res, 400, "{\"error\":\"Invalid user ID format\"}");
                return;
            }
        }
    }

    // Backward-compatible Phase 2 endpoints
    if ((path == "/run" || path == "/execute") && req.method == "POST") {
        handleRunCode(req.body, res);
        return;
    }

    sendJsonResponse(res, 404, "{\"error\":\"Endpoint not found: " + escapeJson(path) + "\"}");
}

void ApiHandler::handleServeFrontend(httplib::Response& res) {
    // Look for demo.html in frontend directory or current working directory
    const vector<string> searchPaths = {
        "frontend/demo.html",
        "./frontend/demo.html",
        "../frontend/demo.html",
        "demo.html",
        "./demo.html",
        "../demo.html"
    };
    string htmlContent;
    bool found = false;

    for (const auto& p : searchPaths) {
        ifstream file(p, ios::in | ios::binary);
        if (file.is_open()) {
            stringstream ss;
            ss << file.rdbuf();
            htmlContent = ss.str();
            found = true;
            break;
        }
    }

    if (!found) {
        res.status = 404;
        res.set_content("<h1>404 Not Found</h1><p>demo.html was not found in the server directory.</p>", "text/html; charset=utf-8");
        return;
    }

    res.status = 200;
    res.set_content(htmlContent, "text/html; charset=utf-8");
}

void ApiHandler::handleRegister(const string& body, httplib::Response& res) {
    string username = extractJsonString(body, "username");
    string email = extractJsonString(body, "email");
    string password = extractJsonString(body, "password");

    if (username.empty() || email.empty() || password.empty()) {
        sendJsonResponse(res, 400, "{\"error\":\"Missing required fields: username, email, password\"}");
        return;
    }

    int userId = 0;
    string errorMsg;
    bool success = DatabaseManager::instance().registerUser(username, email, password, userId, errorMsg);

    if (!success) {
        sendJsonResponse(res, 409, "{\"error\":\"" + escapeJson(errorMsg) + "\"}");
        return;
    }

    stringstream ss;
    ss << "{\"status\":\"ok\",\"user\":{"
       << "\"user_id\":" << userId << ","
       << "\"username\":\"" << escapeJson(username) << "\","
       << "\"email\":\"" << escapeJson(email) << "\""
       << "}}";

    sendJsonResponse(res, 201, ss.str());
}

void ApiHandler::handleLogin(const string& body, httplib::Response& res) {
    string identifier = extractJsonString(body, "identifier");
    if (identifier.empty()) {
        identifier = extractJsonString(body, "username");
    }
    if (identifier.empty()) {
        identifier = extractJsonString(body, "email");
    }
    string password = extractJsonString(body, "password");

    if (identifier.empty() || password.empty()) {
        sendJsonResponse(res, 400, "{\"error\":\"Missing required fields: identifier (or username/email) and password\"}");
        return;
    }

    int userId = 0;
    string username;
    string email;
    string errorMsg;

    bool success = DatabaseManager::instance().loginUser(identifier, password, userId, username, email, errorMsg);
    if (!success) {
        sendJsonResponse(res, 401, "{\"error\":\"" + escapeJson(errorMsg) + "\"}");
        return;
    }

    string statsJson = DatabaseManager::instance().getUserStatsJson(userId);

    stringstream ss;
    ss << "{\"status\":\"ok\","
       << "\"user\":{"
       << "\"user_id\":" << userId << ","
       << "\"username\":\"" << escapeJson(username) << "\","
       << "\"email\":\"" << escapeJson(email) << "\""
       << "},"
       << "\"stats\":" << statsJson
       << "}";

    sendJsonResponse(res, 200, ss.str());
}

void ApiHandler::handleGetProblems(const httplib::Request& req, httplib::Response& res) {
    int userId = 0;
    if (req.has_param("userId")) {
        try { userId = stoi(req.get_param_value("userId")); } catch (...) {}
    } else if (req.has_param("user_id")) {
        try { userId = stoi(req.get_param_value("user_id")); } catch (...) {}
    }

    string problemsJson = DatabaseManager::instance().getProblemsJson(userId);
    sendJsonResponse(res, 200, problemsJson);
}

void ApiHandler::handleGetProblemDetail(int problemId, httplib::Response& res) {
    string detailJson = DatabaseManager::instance().getProblemDetailJson(problemId);
    if (detailJson.empty() || detailJson == "null") {
        sendJsonResponse(res, 404, "{\"error\":\"Problem not found\"}");
        return;
    }
    sendJsonResponse(res, 200, detailJson);
}

void ApiHandler::handlePlaygroundRun(const string& body, httplib::Response& res) {
    string language = extractJsonString(body, "language");
    string code = extractJsonString(body, "code");
    string stdinInput = extractJsonString(body, "stdin");
    if (stdinInput.empty()) {
        stdinInput = extractJsonString(body, "input");
    }

    if (language.empty() || code.empty()) {
        sendJsonResponse(res, 400, "{\"error\":\"Please provide 'language' and 'code' fields in JSON\"}");
        return;
    }

    LanguageConfig langConfig;
    if (!langConfig.isSupported(language)) {
        sendJsonResponse(res, 400, "{\"error\":\"Unsupported language: " + escapeJson(language) + ". Supported: C, C++, Python, Java\"}");
        return;
    }

    auto task = make_shared<Task>();
    task->language = language;
    task->code = code;
    task->stdinInput = stdinInput;

    uint64_t id = taskCounter.fetch_add(1, memory_order_relaxed);
    task->id = "play_" + to_string(GET_PID()) + "_" + to_string(id);

    scheduler.enqueue(task);

    {
        unique_lock<mutex> lock(task->mtx);
        bool finished = task->cv.wait_for(lock, chrono::seconds(15), [&task] { return task->finished; });
        if (!finished) {
            sendJsonResponse(res, 504, "{\"error\":\"Execution timed out or scheduler busy\"}");
            return;
        }
    }

    stringstream json;
    json << "{"
         << "\"status\":\"" << escapeJson(task->status) << "\","
         << "\"stdout\":\"" << escapeJson(task->stdout) << "\","
         << "\"stderr\":\"" << escapeJson(task->stderr) << "\","
         << "\"executionTimeMs\":" << task->executionTimeMs
         << "}";

    sendJsonResponse(res, 200, json.str());
}

void ApiHandler::handleLeetCodeSubmit(const string& body, httplib::Response& res) {
    int userId = extractJsonInt(body, "userId");
    if (userId <= 0) {
        userId = extractJsonInt(body, "user_id", 0);
    }
    bool sampleOnly = extractJsonBool(body, "sampleOnly", false);

    if (!sampleOnly && userId <= 0) {
        sendJsonResponse(res, 401, "{\"error\":\"Authentication required. Please sign in to submit solutions.\"}");
        return;
    }

    int problemId = extractJsonInt(body, "problemId");
    if (problemId <= 0) {
        problemId = extractJsonInt(body, "problem_id");
    }
    string language = extractJsonString(body, "language");
    string code = extractJsonString(body, "code");

    if (problemId <= 0 || language.empty() || code.empty()) {
        sendJsonResponse(res, 400, "{\"error\":\"Missing required fields: problemId, language, code\"}");
        return;
    }

    LanguageConfig langConfig;
    if (!langConfig.isSupported(language)) {
        sendJsonResponse(res, 400, "{\"error\":\"Unsupported language: " + escapeJson(language) + "\"}");
        return;
    }

    vector<DatabaseManager::TestCaseInfo> testCases = DatabaseManager::instance().getTestCases(problemId, sampleOnly);
    if (testCases.empty()) {
        sendJsonResponse(res, 404, "{\"error\":\"No test cases found for problem ID " + to_string(problemId) + "\"}");
        return;
    }

    ResultEvaluator evaluator;
    int passedCount = 0;
    int totalCount = static_cast<int>(testCases.size());
    int totalTimeMs = 0;
    int maxMemoryKb = 15360; // Estimated baseline container memory
    string overallVerdict = "Accepted";

    stringstream tcResultsJson;
    tcResultsJson << "[";

    for (size_t i = 0; i < testCases.size(); i++) {
        const auto& tc = testCases[i];

        auto task = make_shared<Task>();
        task->language = language;
        task->code = code;
        task->stdinInput = tc.input;

        uint64_t id = taskCounter.fetch_add(1, memory_order_relaxed);
        task->id = "judge_" + to_string(GET_PID()) + "_" + to_string(id);

        scheduler.enqueue(task);

        {
            unique_lock<mutex> lock(task->mtx);
            bool finished = task->cv.wait_for(lock, chrono::seconds(15), [&task] { return task->finished; });
            if (!finished) {
                task->status = "Time Limit Exceeded";
                task->finished = true;
            }
        }

        totalTimeMs += task->executionTimeMs;

        // Build command result to evaluate against expected output
        DockerSandbox::CommandResult cmdResult;
        cmdResult.stdout = task->stdout;
        cmdResult.stderr = task->stderr;
        if (task->status == "Accepted") {
            cmdResult.exitCode = 0;
        } else if (task->status == "Time Limit Exceeded") {
            cmdResult.exitCode = 124;
        } else if (task->status == "Memory Limit Exceeded") {
            cmdResult.exitCode = 137;
        } else {
            cmdResult.exitCode = 1;
        }

        string tcVerdict = evaluator.evaluateTestCase(cmdResult, language, tc.expectedOutput);
        if (tcVerdict == "Accepted") {
            passedCount++;
        } else if (overallVerdict == "Accepted") {
            overallVerdict = tcVerdict;
        }

        if (i > 0) tcResultsJson << ",";
        tcResultsJson << "{"
                      << "\"testcase_id\":" << tc.id << ","
                      << "\"is_sample\":" << (tc.isSample ? "true" : "false") << ","
                      << "\"input\":\"" << escapeJson(tc.input) << "\","
                      << "\"expected_output\":\"" << escapeJson(tc.expectedOutput) << "\","
                      << "\"actual_output\":\"" << escapeJson(task->stdout) << "\","
                      << "\"stderr\":\"" << escapeJson(task->stderr) << "\","
                      << "\"verdict\":\"" << escapeJson(tcVerdict) << "\","
                      << "\"execution_time_ms\":" << task->executionTimeMs
                      << "}";
    }

    tcResultsJson << "]";

    // If full submission (not just sample run), record in submissions table
    int submissionId = 0;
    if (!sampleOnly) {
        submissionId = DatabaseManager::instance().recordSubmission(
            userId, problemId, language, code, overallVerdict,
            totalTimeMs, maxMemoryKb, passedCount, totalCount
        );
    }

    stringstream responseJson;
    responseJson << "{"
                 << "\"status\":\"ok\","
                 << "\"submission_id\":" << submissionId << ","
                 << "\"verdict\":\"" << escapeJson(overallVerdict) << "\","
                 << "\"passed_cases\":" << passedCount << ","
                 << "\"total_cases\":" << totalCount << ","
                 << "\"execution_time_ms\":" << totalTimeMs << ","
                 << "\"memory_used_kb\":" << maxMemoryKb << ","
                 << "\"test_cases\":" << tcResultsJson.str()
                 << "}";

    sendJsonResponse(res, 200, responseJson.str());
}

void ApiHandler::handleGetLeaderboard(httplib::Response& res) {
    string lbJson = DatabaseManager::instance().getLeaderboardJson(50);
    sendJsonResponse(res, 200, lbJson);
}

void ApiHandler::handleGetUserSubmissions(int userId, httplib::Response& res) {
    string subsJson = DatabaseManager::instance().getUserSubmissionsJson(userId, 30);
    sendJsonResponse(res, 200, subsJson);
}

// POST /run: backward compatible Phase 2 endpoint
void ApiHandler::handleRunCode(const string& body, httplib::Response& res) {
    handlePlaygroundRun(body, res);
}

string ApiHandler::extractJsonString(const string& json, const string& field) {
    string key = "\"" + field + "\"";
    size_t keyPos = json.find(key);
    if (keyPos == string::npos) return "";

    size_t pos = keyPos + key.length();
    while (pos < json.length() && (json[pos] == ' ' || json[pos] == '\t' || json[pos] == '\r' || json[pos] == '\n')) pos++;
    if (pos >= json.length() || json[pos] != ':') return "";
    pos++;

    while (pos < json.length() && (json[pos] == ' ' || json[pos] == '\t' || json[pos] == '\r' || json[pos] == '\n')) pos++;
    if (pos >= json.length() || json[pos] != '"') return "";
    pos++;

    string value;
    value.reserve(256);
    while (pos < json.length()) {
        char c = json[pos];
        if (c == '"') return value;
        if (c == '\\') {
            pos++;
            if (pos >= json.length()) break;
            char esc = json[pos];
            switch (esc) {
                case '"':  value += '"'; break;
                case '\\': value += '\\'; break;
                case '/':  value += '/'; break;
                case 'b':  value += '\b'; break;
                case 'f':  value += '\f'; break;
                case 'n':  value += '\n'; break;
                case 'r':  value += '\r'; break;
                case 't':  value += '\t'; break;
                case 'u': {
                    if (pos + 4 < json.length()) {
                        string hex = json.substr(pos + 1, 4);
                        try {
                            unsigned long cp = stoul(hex, nullptr, 16);
                            value += (cp <= 0x7F) ? static_cast<char>(cp) : '?';
                        } catch (...) {}
                        pos += 4;
                    }
                    break;
                }
                default:
                    value += esc;
                    break;
            }
        } else {
            value += c;
        }
        pos++;
    }
    return value;
}

int ApiHandler::extractJsonInt(const string& json, const string& field, int defaultValue) {
    string key = "\"" + field + "\"";
    size_t keyPos = json.find(key);
    if (keyPos == string::npos) return defaultValue;

    size_t pos = keyPos + key.length();
    while (pos < json.length() && (json[pos] == ' ' || json[pos] == '\t' || json[pos] == '\r' || json[pos] == '\n')) pos++;
    if (pos >= json.length() || json[pos] != ':') return defaultValue;
    pos++;

    while (pos < json.length() && (json[pos] == ' ' || json[pos] == '\t' || json[pos] == '\r' || json[pos] == '\n')) pos++;
    if (pos >= json.length()) return defaultValue;

    if (json[pos] == '"') {
        pos++;
        size_t endQuote = json.find('"', pos);
        if (endQuote != string::npos) {
            try { return stoi(json.substr(pos, endQuote - pos)); } catch (...) { return defaultValue; }
        }
        return defaultValue;
    }

    size_t start = pos;
    while (pos < json.length() && (isdigit(static_cast<unsigned char>(json[pos])) || json[pos] == '-')) {
        pos++;
    }
    if (pos > start) {
        try {
            return stoi(json.substr(start, pos - start));
        } catch (...) {
            return defaultValue;
        }
    }
    return defaultValue;
}

bool ApiHandler::extractJsonBool(const string& json, const string& field, bool defaultValue) {
    string key = "\"" + field + "\"";
    size_t keyPos = json.find(key);
    if (keyPos == string::npos) return defaultValue;

    size_t pos = keyPos + key.length();
    while (pos < json.length() && (json[pos] == ' ' || json[pos] == '\t' || json[pos] == '\r' || json[pos] == '\n')) pos++;
    if (pos >= json.length() || json[pos] != ':') return defaultValue;
    pos++;

    while (pos < json.length() && (json[pos] == ' ' || json[pos] == '\t' || json[pos] == '\r' || json[pos] == '\n')) pos++;
    if (pos >= json.length()) return defaultValue;

    if (json.compare(pos, 4, "true") == 0) return true;
    if (json.compare(pos, 5, "false") == 0) return false;
    return defaultValue;
}

void ApiHandler::sendJsonResponse(httplib::Response& res, int status, const string& jsonBody) {
    res.status = status;
    res.set_content(jsonBody, "application/json");
}

string ApiHandler::escapeJson(const string& s) {
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
