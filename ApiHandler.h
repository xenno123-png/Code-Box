#pragma once

#include "QueueScheduler.h"
#include "httplib.h"
#include <atomic>
#include <string>

using namespace std;

// Handles HTTP requests and coordinates with QueueScheduler
class ApiHandler {
public:
    ApiHandler(QueueScheduler& sched);
    void handle(const httplib::Request& req, httplib::Response& res);

private:
    void handleRunCode(const string& body, httplib::Response& res);
    string extractJsonString(const string& json, const string& field);
    void sendJsonResponse(httplib::Response& res, int status, const string& jsonBody);
    string escapeJson(const string& s);

    QueueScheduler& scheduler;
    atomic<uint64_t> taskCounter{0};
};