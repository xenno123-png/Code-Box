#include "Headers.h"

namespace {
string toLower(string s) {
    transform(s.begin(), s.end(), s.begin(), [](unsigned char c) { return static_cast<char>(tolower(c)); });
    return s;
}
}

bool LanguageConfig::isSupported(const string& language) const {
    string lang = toLower(language);
    return lang == "c" || lang == "cpp" || lang == "c++" || lang == "python" || lang == "py" || lang == "java";
}

string LanguageConfig::getFileExtension(const string& language) const {
    string lang = toLower(language);
    if (lang == "c") return "c";
    if (lang == "cpp" || lang == "c++") return "cpp";
    if (lang == "python" || lang == "py") return "py";
    if (lang == "java") return "java";
    return "";
}

string LanguageConfig::getRunCommand(const string& language, const string& sourceFile, const string& inputFile) const {
    string lang = toLower(language);

    string fileName = sourceFile;
    size_t slashPos = sourceFile.find_last_of("/\\");
    if (slashPos != string::npos) {
        fileName = sourceFile.substr(slashPos + 1);
    }

    string stem = fileName;
    size_t dotPos = fileName.find_last_of('.');
    if (dotPos != string::npos) {
        stem = fileName.substr(0, dotPos);
    }

    string inputRedirection = !inputFile.empty() ? " < input.txt" : "";

    string image;
    string innerCommand;

    if (lang == "python" || lang == "py") {
        image = "python:3";
        innerCommand = "timeout 2s python3 " + fileName + inputRedirection;
    } else if (lang == "c") {
        image = "gcc:latest";
        innerCommand = "gcc " + fileName + " -o " + stem + " && timeout 2s ./" + stem + inputRedirection;
    } else if (lang == "java") {
        image = "openjdk:17";
        innerCommand = "javac " + fileName + " && timeout 2s java " + stem + inputRedirection;
    } else {
        image = "gcc:latest";
        innerCommand = "g++ -std=c++17 " + fileName + " -o " + stem + " && timeout 2s ./" + stem + inputRedirection;
    }

    string containerPath = "/code/" + fileName;

    string volumes = "-v \"" + sourceFile + ":" + containerPath + "\"";
    if (!inputFile.empty()) {
        volumes += " -v \"" + inputFile + ":/code/input.txt\"";
    }

    string command = "timeout 10s docker run --rm "
                     "--memory=\"256m\" --memory-swap=\"256m\" --cpus=\"1.0\" --pids-limit=64 --network=none "
                     "-w /code " + volumes + " "
                     + image + " bash -c \"" + innerCommand + "\"";

    return command;
}