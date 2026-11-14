#include "Headers.h"

namespace {
string toLower(string s) {
    transform(s.begin(), s.end(), s.begin(), [](unsigned char c) { return static_cast<char>(tolower(c)); });
    return s;
}
}

string ResultEvaluator::evaluate(const DockerSandbox::CommandResult& result, const string& language) const {
    string lang = toLower(language);

    // 1. Time Limit Exceeded: GNU timeout exits with 124 on expiry
    if (result.exitCode == 124) return "Time Limit Exceeded";

    // 2. Memory Limit Exceeded: Linux cgroups OOM killer sends SIGKILL (128 + 9 = 137)
    if (result.exitCode == 137) return "Memory Limit Exceeded";

    // 3. Accepted: clean execution
    if (result.exitCode == 0) return "Accepted";

    // 4. Compilation errors for compiled languages (C, C++, Java)
    if (lang == "c" || lang == "cpp" || lang == "c++") {
        if (result.stderr.find("error:") != string::npos ||
            result.stderr.find("Error:") != string::npos ||
            result.stderr.find("fatal error:") != string::npos ||
            result.stderr.find("undefined reference") != string::npos ||
            result.stderr.find("ld returned 1 exit status") != string::npos) {
            return "Compilation Error";
        }
    } else if (lang == "java") {
        if (result.stderr.find("error:") != string::npos ||
            result.stderr.find("Error:") != string::npos ||
            result.stderr.find("cannot find symbol") != string::npos ||
            result.stderr.find("class, interface, or enum expected") != string::npos ||
            result.stderr.find("reached end of file while parsing") != string::npos) {
            return "Compilation Error";
        }
    }

    // 5. Syntax errors for Python
    if (lang == "python" || lang == "py") {
        if (result.stderr.find("SyntaxError") != string::npos ||
            result.stderr.find("IndentationError") != string::npos ||
            result.stderr.find("TabError") != string::npos) {
            return "Compilation Error";
        }
    }

    // 6. Runtime errors: exceptions, segfaults, and non-zero exit codes
    return "Runtime Error";
}

namespace {
string trim(const string& s) {
    size_t start = 0;
    while (start < s.size() && (s[start] == ' ' || s[start] == '\t' || s[start] == '\r' || s[start] == '\n')) {
        start++;
    }
    size_t end = s.size();
    while (end > start && (s[end - 1] == ' ' || s[end - 1] == '\t' || s[end - 1] == '\r' || s[end - 1] == '\n')) {
        end--;
    }
    return s.substr(start, end - start);
}

string normalizeNewlines(const string& s) {
    string res;
    res.reserve(s.size());
    for (size_t i = 0; i < s.size(); i++) {
        if (s[i] == '\r') {
            if (i + 1 < s.size() && s[i + 1] == '\n') continue;
            res += '\n';
        } else {
            res += s[i];
        }
    }
    return res;
}
}

string ResultEvaluator::evaluateTestCase(const DockerSandbox::CommandResult& result, const string& language, const string& expectedOutput) const {
    string verdict = evaluate(result, language);
    if (verdict != "Accepted") {
        return verdict;
    }

    string outTrimmed = normalizeNewlines(trim(result.stdout));
    string expTrimmed = normalizeNewlines(trim(expectedOutput));

    if (outTrimmed == expTrimmed) {
        return "Accepted";
    }

    return "Wrong Answer";
}