#pragma once

#include "QueueScheduler.h"
#include "httplib.h"
#include <atomic>
#include <string>

using namespace std;

// Handles HTTP requests and coordinates with QueueScheduler and DatabaseManager
class ApiHandler {
public:
    ApiHandler(QueueScheduler& sched);
    void handle(const httplib::Request& req, httplib::Response& res);

private:
    void handleServeFrontend(httplib::Response& res);
    void handleRegister(const string& body, httplib::Response& res);
    void handleLogin(const string& body, httplib::Response& res);
    void handleGetProblems(const httplib::Request& req, httplib::Response& res);
    void handleGetProblemDetail(int problemId, httplib::Response& res);
    void handlePlaygroundRun(const string& body, httplib::Response& res);
    void handleLeetCodeSubmit(const string& body, httplib::Response& res);
    void handleGetLeaderboard(httplib::Response& res);
    void handleGetUserSubmissions(int userId, httplib::Response& res);
    void handleRunCode(const string& body, httplib::Response& res);

    string extractJsonString(const string& json, const string& field);
    int extractJsonInt(const string& json, const string& field, int defaultValue = 0);
    bool extractJsonBool(const string& json, const string& field, bool defaultValue = false);
    void sendJsonResponse(httplib::Response& res, int status, const string& jsonBody);
    string escapeJson(const string& s);

    QueueScheduler& scheduler;
    atomic<uint64_t> taskCounter{0};
};
