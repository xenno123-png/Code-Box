# ==============================================================================
# CodeBox: Containerized Code Execution Engine
# Production-Grade Makefile for Systems & Backend C++ Service
# ==============================================================================

# Compiler selection and standard
CXX      ?= g++
CXXFLAGS ?= -std=c++17 -pthread

# Output target name
TARGET   := codebox_server

# Build directories
BUILD_DIR := obj
BIN_DIR   := .

# Source and Object files
SRCS     := main.cpp \
            ApiHandler.cpp \
            QueueScheduler.cpp \
            DockerSandbox.cpp \
            FileManager.cpp \
            LanguageConfig.cpp \
            ResultEvaluator.cpp \
            DatabaseManager.cpp

OBJS     := $(SRCS:%.cpp=$(BUILD_DIR)/%.o)
DEPS     := $(OBJS:.o=.d)

# Base Warning & Diagnostic Flags
WARN_FLAGS := -Wall -Wextra -Wpedantic -Wshadow -Wnon-virtual-dtor \
              -Wold-style-cast -Wcast-align -Wunused -Woverloaded-virtual

# Build Configuration: Release (default) vs Debug
# Usage:
#   make            -> Optimized Release build (-O2)
#   make DEBUG=1    -> Debug build (-O0 -g3)
#   make ASAN=1     -> Address & Undefined Behavior Sanitizer enabled
ifeq ($(DEBUG), 1)
    OPT_FLAGS   := -O0 -g3 -DDEBUG
else
    OPT_FLAGS   := -O2 -DNDEBUG
endif

ifeq ($(ASAN), 1)
    OPT_FLAGS   += -fsanitize=address,undefined -fno-omit-frame-pointer
    LDFLAGS     += -fsanitize=address,undefined
endif

# Dependency generation flags (-MMD -MP)
DEP_FLAGS := -MMD -MP

# Final compiler flags
CXXFLAGS += $(OPT_FLAGS) $(WARN_FLAGS) $(DEP_FLAGS)
LDFLAGS  += -pthread -lsqlite3

# Cross-platform command helpers
ifeq ($(OS),Windows_NT)
    MKDIR_P := powershell -Command "New-Item -ItemType Directory -Force -Path"
    RM_RF   := powershell -Command "Remove-Item -Recurse -Force -ErrorAction SilentlyContinue"
    EXE_EXT := .exe
else
    MKDIR_P := mkdir -p
    RM_RF   := rm -rf
    EXE_EXT :=
endif

TARGET_BIN := $(BIN_DIR)/$(TARGET)$(EXE_EXT)

# ==============================================================================
# Targets
# ==============================================================================

.PHONY: all release debug run clean distclean help

# Default target (compiles and automatically launches server)
all: run

release: $(TARGET_BIN)

debug:
	$(MAKE) DEBUG=1

# Linking the final executable
$(TARGET_BIN): $(OBJS) | $(BIN_DIR)
	@echo "==> Linking target: $@"
	$(CXX) $(OBJS) $(LDFLAGS) -o $@
	@echo "==> Build successful: $@"

# Compiling source files into object files (with automatic dependency tracking)
$(BUILD_DIR)/%.o: %.cpp | $(BUILD_DIR)
	@echo "==> Compiling: $<"
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Directory creation targets
$(BUILD_DIR):
	@$(MKDIR_P) $(BUILD_DIR)

# Include generated header dependency files (.d)
-include $(DEPS)

# Run the compiled server
run: $(TARGET_BIN)
	@echo "==> Launching CodeBox engine..."
	./$(TARGET)$(EXE_EXT)

# Clean build artifacts
clean:
	@echo "==> Cleaning build artifacts..."
	$(RM_RF) $(BUILD_DIR) $(TARGET_BIN) $(TARGET)
	@echo "==> Clean complete."

distclean: clean
	@echo "==> Full reset complete."

# Help menu
help:
	@echo "CodeBox Build System"
	@echo "--------------------"
	@echo "Available targets:"
	@echo "  make              : Compile release build (optimized -O2)"
	@echo "  make debug        : Compile debug build (-g3 -O0)"
	@echo "  make ASAN=1       : Compile with AddressSanitizer and UndefinedBehaviorSanitizer"
	@echo "  make run          : Compile and run the code execution engine"
	@echo "  make clean        : Remove object files and compiled binary"
	@echo "  make help         : Show this documentation"