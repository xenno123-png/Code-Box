#pragma once

#include <sqlite3.h>
#include <string>
#include <vector>
#include <mutex>
#include <memory>

using namespace std;

// DatabaseManager handles all SQLite3 database operations, 3NF schema management,
// user authentication, problem catalog, test cases, submissions, and leaderboard.
class DatabaseManager {
public:
    struct TestCaseInfo {
        int id;
        int problemId;
        string input;
        string expectedOutput;
        bool isSample;
    };

    DatabaseManager();
    ~DatabaseManager();

    // Non-copyable
    DatabaseManager(const DatabaseManager&) = delete;
    DatabaseManager& operator=(const DatabaseManager&) = delete;

    // Singleton access helper
    static DatabaseManager& instance();

    // Initialize database connection
    bool init(const string& dbPath = "codebox.db");
    void close();

    // Executes schema.sql and seed_problems.sql if tables do not exist
    bool autoInitialize(const string& schemaPath = "database/schema.sql", 
                        const string& seedPath = "database/seed_problems.sql");

    // Executes a raw .sql file with multiple statements
    bool executeScript(const string& scriptPath);

    // User Authentication
    bool registerUser(const string& username, const string& email, const string& password, 
                      int& outUserId, string& outError);
    bool loginUser(const string& identifier, const string& password, 
                   int& outUserId, string& outUsername, string& outEmail, string& outError);
    string getUserStatsJson(int userId);

    // Problem Catalog
    string getProblemsJson(int userId = 0);
    string getProblemDetailJson(int problemId);
    vector<TestCaseInfo> getTestCases(int problemId, bool sampleOnly = false);

    // Submissions & Leaderboard
    int recordSubmission(int userId, int problemId, const string& language, const string& sourceCode, 
                         const string& verdict, int executionTimeMs, int memoryUsedKb, 
                         int passedCases, int totalCases);
    string getUserSubmissionsJson(int userId, int limit = 20);
    string getLeaderboardJson(int limit = 50);

    // Utilities
    int getLanguageId(const string& langName);
    static string escapeJson(const string& s);

private:
    sqlite3* db = nullptr;
    string dbFilePath = "codebox.db";
    mutex dbMtx;
};
