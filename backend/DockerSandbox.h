#pragma once

#include <string>

using namespace std;

// Runs commands inside Docker containers with resource and time limits
class DockerSandbox {
public:
    struct CommandResult {
        string stdout;
        string stderr;
        int exitCode;
    };

    CommandResult executeCommand(const string& shellCommand);
    CommandResult runCode(const string& language, const string& sourceFile, const string& inputFile = "");
};