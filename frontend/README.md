# CodeBox - Frontend Module (Phase 3 Full-Stack SPA)

This directory contains the user interface for CodeBox — a modern, responsive Single Page Application (SPA) designed with dark mode, high-contrast syntax highlighting, and fluid split-pane draggable resizing.

---

## 🚀 Key Features

### 1. Mandatory Authentication Gate
- **Zero-Access Security**: Locks the entire platform behind a sleek, full-screen authentication modal until the user registers or logs in.
- **Session Persistence**: Stores `codebox_user` in browser `localStorage`.
- **Global Leaderboard Transparency**: Displays user stats, solved counts, and real-time rank.

### 2. Practice Questions (DSA Problem Catalog & Multi-Language Judge)
- **Collapsible Problem Drawer**: Toggleable problem list with filter by Difficulty (Easy, Medium, Hard) and Category (Arrays, Strings, Dynamic Programming, Trees, etc.).
- **Proportional Layout**: Problem Description (42%) and Code Editor (58%) with mouse-draggable vertical split-pane separator (`col-resize`).
- **Interactive Multi-Language Tabs**: Instant starter templates for **C (GCC)**, **C++17**, **Python 3**, and **Java 17**.
- **Integrated Test Runner**: Run sample test cases or submit code to execute against all hidden test cases in real-time with detailed verdicts (Accepted, Wrong Answer, TLE, Compilation Error, Runtime Error).
- **Draggable Bottom Console**: Smooth vertical resize handle (`row-resize`) to expand/collapse test case inputs, compiler diagnostics, and execution statistics.

### 3. Coding Platform (VS Code-Style Studio)
- **File Explorer Sidebar**: Switch between `main.c`, `main.cpp`, `main.py`, and `Solution.java`.
- **Full Monaco Editor**: Microsoft Monaco Editor instance with auto-completion, line numbers, bracket matching, and theme customization (`vs-dark`).
- **Unified Terminal / Output**: Single full-width VS Code-style console with integrated prompt, standard input, and stdout/stderr execution stream.
- **Draggable Resizers**: Full mouse-drag split resizing between the file tree and code editor, as well as between the editor and terminal drawer.

---

## 🛠️ Tech Stack
- **Framework**: Single Page Application (Vanilla ES6+ JS)
- **Styling**: Tailwind CSS CDN + Custom Dark Theme CSS
- **Code Editor**: Microsoft Monaco Editor CDN
- **Fonts & Icons**: JetBrains Mono, Inter, and Lucide/FontAwesome SVG icons
