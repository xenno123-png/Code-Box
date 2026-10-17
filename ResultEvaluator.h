#pragma once

#include "DockerSandbox.h"
#include <string>

using namespace std;

// Evaluates execution output and exit code into a verdict string
class ResultEvaluator {
public:
    string evaluate(const DockerSandbox::CommandResult& result, const string& language) const;
};