#pragma once

#include <string>

using namespace std;

// Handles writing submitted user code to /tmp and cleaning it up after execution
class FileManager {
public:
    string saveCodeToFile(const string& code, const string& extension);
    void deleteFile(const string& filepath);
};