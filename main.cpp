#include "Headers.h"

// Pointer to server instance for clean shutdown from signal handler
static httplib::Server* g_server = nullptr;

extern "C" void handleShutdownSignal(int signum) {
    cout << "\nReceived signal (" << signum << "), shutting down..." << endl;
    if (g_server) g_server->stop();
}

int main() {
    cout << "Starting CodeBox backend..." << endl;

    // Launch worker threads (max 3 concurrent jobs)
    QueueScheduler scheduler;
    scheduler.start();

    ApiHandler handler(scheduler);

    httplib::Server server;
    g_server = &server;

    signal(SIGINT, handleShutdownSignal);
#ifndef _WIN32
    signal(SIGTERM, handleShutdownSignal);
#endif

    server.Get("/health", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });
    server.Post("/run", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });
    server.Post("/execute", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });
    server.Options(".*", [&](const httplib::Request& req, httplib::Response& res) { handler.handle(req, res); });

    cout << "Server listening on http://0.0.0.0:8080" << endl;
    if (!server.listen("0.0.0.0", 8080)) {
        cerr << "Failed to start server on port 8080" << endl;
        scheduler.stop();
        return 1;
    }

    scheduler.stop();
    cout << "CodeBox shutdown complete." << endl;
    return 0;
}