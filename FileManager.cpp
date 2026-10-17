#include "Headers.h"

// Atomic counter to avoid filename collisions when workers run concurrently
static atomic<uint64_t> fileCounter{0};

string FileManager::saveCodeToFile(const string& code, const string& extension) {
    uint64_t currentCount = fileCounter.fetch_add(1, memory_order_relaxed);
    auto timestamp = chrono::steady_clock::now().time_since_epoch().count();

    string fileBase = "codebox_" + to_string(GET_PID()) + "_" + to_string(timestamp) + "_" + to_string(currentCount);
    string filepath;

    if (extension == "java") {
        // Java requires filename to match the public class name (e.g. Solution.java)
        string className;
        size_t pos = 0;
        while ((pos = code.find("class", pos)) != string::npos) {
            if (pos > 0 && (isalnum(static_cast<unsigned char>(code[pos - 1])) || code[pos - 1] == '_')) {
                pos += 5;
                continue;
            }
            size_t nameStart = pos + 5;
            if (nameStart >= code.size() || !isspace(static_cast<unsigned char>(code[nameStart]))) {
                pos += 5;
                continue;
            }
            while (nameStart < code.size() && isspace(static_cast<unsigned char>(code[nameStart]))) {
                nameStart++;
            }
            size_t nameEnd = nameStart;
            while (nameEnd < code.size() && (isalnum(static_cast<unsigned char>(code[nameEnd])) || code[nameEnd] == '_')) {
                nameEnd++;
            }
            if (nameEnd > nameStart) {
                className = code.substr(nameStart, nameEnd - nameStart);
                break;
            }
            pos = nameEnd;
        }

        if (!className.empty()) {
            string dirPath = "/tmp/" + fileBase;
            MKDIR(dirPath.c_str());
            filepath = dirPath + "/" + className + ".java";
        } else {
            filepath = "/tmp/" + fileBase + ".java";
        }
    } else {
        filepath = "/tmp/" + fileBase + "." + extension;
    }

    ofstream file(filepath, ios::out | ios::binary);
    if (!file.is_open()) {
        cerr << "FileManager: could not create file " << filepath << endl;
        return "";
    }

    file << code;
    file.close();

    cout << "FileManager: saved code to " << filepath << endl;
    return filepath;
}

void FileManager::deleteFile(const string& filepath) {
    if (filepath.empty()) return;

    if (remove(filepath.c_str()) == 0) {
        cout << "FileManager: deleted " << filepath << endl;
    } else {
        cerr << "FileManager: failed to delete " << filepath << endl;
    }

    size_t lastSlash = filepath.find_last_of("/\\");
    if (lastSlash != string::npos) {
        string parentDir = filepath.substr(0, lastSlash);
        if (parentDir.find("codebox_") != string::npos) {
            RMDIR(parentDir.c_str());
        }
    }
}