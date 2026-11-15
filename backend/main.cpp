#include "Headers.h"

// Pointer to server instance for clean shutdown from signal handler
static httplib::Server* g_server = nullptr;

extern "C" void handleShutdownSignal(int signum) {
    cout << "\nReceived signal (" << signum << "), shutting down..." << endl;
    if (g_server) g_server->stop();
}

int main() {
    cout << "====================================================" << endl;
    cout << "  CodeBox v3.0: Online Coding & Judge Platform      " << endl;
    cout << "====================================================" << endl;

    // 1. Initialize Strict 3NF Relational Database (SQLite3)
    cout << "[Init] Checking SQLite database & 3NF schema..." << endl;
    if (!DatabaseManager::instance().autoInitialize()) {
        cerr << "[Error] Failed to initialize database! Exiting." << endl;
        return 1;
    }

    // 2. Launch worker threads (3 concurrent execution workers)
    cout << "[Init] Starting QueueScheduler worker pool (3 FCFS threads)..." << endl;
    QueueScheduler scheduler;
    scheduler.start();

    ApiHandler handler(scheduler);

    httplib::Server server;
    g_server = &server;

    signal(SIGINT, handleShutdownSignal);
#ifndef _WIN32
    signal(SIGTERM, handleShutdownSignal);
#endif

    // Frontend Web Asset Routes
    server.Get("/", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });
    server.Get("/index.html", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });
    server.Get("/front_end.html", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });
    server.Get("/demo.html", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });

    // Health Check
    server.Get("/health", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });

    // Authentication Routes
    server.Post("/api/register", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });
    server.Post("/api/login", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });

    // Problem Catalog Routes
    server.Get("/api/problems", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });
    server.Get(R"(/api/problems/\d+)", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });

    // Code Execution & Judge Routes
    server.Post("/api/playground/run", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });
    server.Post("/api/leetcode/submit", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });

    // Leaderboard & User Submissions
    server.Get("/api/leaderboard", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });
    server.Get(R"(/api/user/\d+/submissions)", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });

    // Backward Compatible Phase 2 Routes
    server.Post("/run", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });
    server.Post("/execute", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });

    // CORS preflight options
    server.Options(".*", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });

    cout << "[Ready] Server listening on http://0.0.0.0:8080" << endl;
    cout << "        Open http://localhost:8080 in your browser" << endl;
    if (!server.listen("0.0.0.0", 8080)) {
        cerr << "[Error] Failed to bind to port 8080" << endl;
        scheduler.stop();
        return 1;
    }

    scheduler.stop();
    cout << "CodeBox shutdown complete." << endl;
    return 0;
}
