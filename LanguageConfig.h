#pragma once

#include <string>

using namespace std;

// Configuration for supported languages and Docker run commands
class LanguageConfig {
public:
    bool isSupported(const string& language) const;
    string getFileExtension(const string& language) const;
    string getRunCommand(const string& language, const string& sourceFile) const;
};