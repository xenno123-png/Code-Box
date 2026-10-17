#include "Headers.h"

ApiHandler::ApiHandler(QueueScheduler& sched) : scheduler(sched), taskCounter(0) {}

void ApiHandler::handle(const httplib::Request& req, httplib::Response& res) {
    res.set_header("Access-Control-Allow-Origin", "*");
    res.set_header("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
    res.set_header("Access-Control-Allow-Headers", "Content-Type");

    if (req.method == "OPTIONS") {
        res.status = 200;
        return;
    }

    string path = req.path;
    if (path == "/run" || path == "/execute") {
        handleRunCode(req.body, res);
    } else if (path == "/health") {
        sendJsonResponse(res, 200, "{\"status\":\"ok\"}");
    } else {
        sendJsonResponse(res, 404, "{\"error\":\"Endpoint not found. Use POST /run\"}");
    }
}

// POST /run: parse input, enqueue task, wait with timeout, return JSON
void ApiHandler::handleRunCode(const string& body, httplib::Response& res) {
    string language = extractJsonString(body, "language");
    string code = extractJsonString(body, "code");

    if (language.empty() || code.empty()) {
        sendJsonResponse(res, 400, "{\"error\":\"Please provide 'language' and 'code' fields in JSON\"}");
        return;
    }

    LanguageConfig langConfig;
    if (!langConfig.isSupported(language)) {
        sendJsonResponse(res, 400, "{\"error\":\"Unsupported language: " + escapeJson(language) + ". Supported: C, C++, Python, Java\"}");
        return;
    }

    auto task = make_shared<Task>();
    task->language = language;
    task->code = code;

    uint64_t id = taskCounter.fetch_add(1, memory_order_relaxed);
    task->id = "task_" + to_string(GET_PID()) + "_" + to_string(id);

    scheduler.enqueue(task);

    {
        unique_lock<mutex> lock(task->mtx);
        bool finished = task->cv.wait_for(lock, chrono::seconds(15), [&task] { return task->finished; });
        if (!finished) {
            sendJsonResponse(res, 504, "{\"error\":\"Execution timed out or scheduler busy\"}");
            return;
        }
    }

    stringstream json;
    json << "{"
         << "\"status\":\"" << escapeJson(task->status) << "\","
         << "\"stdout\":\"" << escapeJson(task->stdout) << "\","
         << "\"stderr\":\"" << escapeJson(task->stderr) << "\""
         << "}";

    sendJsonResponse(res, 200, json.str());
}

string ApiHandler::extractJsonString(const string& json, const string& field) {
    string key = "\"" + field + "\"";
    size_t keyPos = json.find(key);
    if (keyPos == string::npos) return "";

    size_t pos = keyPos + key.length();
    while (pos < json.length() && (json[pos] == ' ' || json[pos] == '\t' || json[pos] == '\r' || json[pos] == '\n')) pos++;
    if (pos >= json.length() || json[pos] != ':') return "";
    pos++;

    while (pos < json.length() && (json[pos] == ' ' || json[pos] == '\t' || json[pos] == '\r' || json[pos] == '\n')) pos++;
    if (pos >= json.length() || json[pos] != '"') return "";
    pos++;

    string value;
    value.reserve(256);
    while (pos < json.length()) {
        char c = json[pos];
        if (c == '"') return value;
        if (c == '\\') {
            pos++;
            if (pos >= json.length()) break;
            char esc = json[pos];
            switch (esc) {
                case '"':  value += '"'; break;
                case '\\': value += '\\'; break;
                case '/':  value += '/'; break;
                case 'b':  value += '\b'; break;
                case 'f':  value += '\f'; break;
                case 'n':  value += '\n'; break;
                case 'r':  value += '\r'; break;
                case 't':  value += '\t'; break;
                case 'u': {
                    if (pos + 4 < json.length()) {
                        string hex = json.substr(pos + 1, 4);
                        try {
                            unsigned long cp = stoul(hex, nullptr, 16);
                            value += (cp <= 0x7F) ? static_cast<char>(cp) : '?';
                        } catch (...) {}
                        pos += 4;
                    }
                    break;
                }
                default:
                    value += esc;
                    break;
            }
        } else {
            value += c;
        }
        pos++;
    }
    return value;
}

void ApiHandler::sendJsonResponse(httplib::Response& res, int status, const string& jsonBody) {
    res.status = status;
    res.set_content(jsonBody, "application/json");
}

string ApiHandler::escapeJson(const string& s) {
    string out;
    out.reserve(s.size() + 32);
    for (char c : s) {
        switch (c) {
            case '"':  out += "\\\""; break;
            case '\\': out += "\\\\"; break;
            case '\b': out += "\\b"; break;
            case '\f': out += "\\f"; break;
            case '\n': out += "\\n"; break;
            case '\r': out += "\\r"; break;
            case '\t': out += "\\t"; break;
            default:
                if (static_cast<unsigned char>(c) < 0x20) {
                    char buf[8];
                    snprintf(buf, sizeof(buf), "\\u%04x", static_cast<unsigned char>(c));
                    out += buf;
                } else {
                    out += c;
                }
                break;
        }
    }
    return out;
}