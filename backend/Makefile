# ==============================================================================
# CodeBox: Backend Subdirectory Makefile
# Allows running make directly inside backend/
# ==============================================================================

CXX      ?= g++
CXXFLAGS ?= -std=c++17 -pthread -O2 -Wall -Wextra -I.
LDFLAGS  += -pthread -lsqlite3
TARGET   := ../codebox_server

SRCS     := main.cpp \
            ApiHandler.cpp \
            QueueScheduler.cpp \
            DockerSandbox.cpp \
            FileManager.cpp \
            LanguageConfig.cpp \
            ResultEvaluator.cpp \
            DatabaseManager.cpp

OBJS     := $(SRCS:%.cpp=../obj/backend_%.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p ../obj
	$(CXX) $(OBJS) $(LDFLAGS) -o $@

../obj/backend_%.o: %.cpp
	@mkdir -p ../obj
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
