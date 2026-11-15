#!/usr/bin/env python3
"""
CodeBox: Master Technical & Systems Architecture Guide (Formal Academic English)
Generates DETAILS/CodeBox.pdf in pristine, formal academic English for university evaluation and GitHub repository.
Replaces all colloquial Hinglish with professional computer science terminology.
"""

import os
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, HRFlowable
)
from reportlab.pdfgen import canvas

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super(NumberedCanvas, self).__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super(NumberedCanvas, self).showPage()
        super(NumberedCanvas, self).save()

    def draw_page_decorations(self, page_count):
        self.saveState()
        self.setFont("Helvetica-Bold", 8)
        self.setFillColor(colors.HexColor("#64748B"))

        # Running Top Header
        self.drawString(54, letter[1] - 36, "CODEBOX: MASTER TECHNICAL & ARCHITECTURAL DEFENSE GUIDE")
        self.setFont("Helvetica", 8)
        self.drawRightString(letter[0] - 54, letter[1] - 36, "Systems Engineering Specification")

        # Top rule
        self.setStrokeColor(colors.HexColor("#CBD5E1"))
        self.setLineWidth(0.75)
        self.line(54, letter[1] - 42, letter[0] - 54, letter[1] - 42)

        # Running Bottom Footer
        self.line(54, 45, letter[0] - 54, 45)
        self.setFont("Helvetica", 8)
        self.drawString(54, 32, "B.Tech Computer Science & Engineering | Team ayush908828")
        page_str = f"Page {self._pageNumber} of {page_count}"
        self.drawRightString(letter[0] - 54, 32, page_str)
        self.restoreState()


def build_codebox_pdf(output_path):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    doc = SimpleDocTemplate(
        output_path,
        pagesize=letter,
        leftMargin=54,
        rightMargin=54,
        topMargin=54,
        bottomMargin=54
    )

    styles = getSampleStyleSheet()

    c_primary = colors.HexColor("#1E3A8A")     # Navy Blue
    c_secondary = colors.HexColor("#0D9488")   # Teal
    c_dark = colors.HexColor("#0F172A")        # Slate 900
    c_body = colors.HexColor("#334155")        # Slate 700
    c_callout_bg = colors.HexColor("#F8FAFC")  # Subtle Slate
    c_callout_border = colors.HexColor("#2563EB") # Royal Blue

    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=20,
        leading=24,
        textColor=c_primary,
        spaceAfter=4
    )

    subtitle_style = ParagraphStyle(
        'DocSubTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=10.5,
        leading=14,
        textColor=c_secondary,
        spaceAfter=8
    )

    h1_style = ParagraphStyle(
        'Header1',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=12,
        leading=16,
        textColor=c_primary,
        spaceBefore=10,
        spaceAfter=4,
        keepWithNext=True
    )

    h2_style = ParagraphStyle(
        'Header2',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=9.5,
        leading=13,
        textColor=c_dark,
        spaceBefore=6,
        spaceAfter=3,
        keepWithNext=True
    )

    body_style = ParagraphStyle(
        'BodyTextCustom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8.5,
        leading=12,
        textColor=c_body,
        spaceAfter=5
    )

    th_style = ParagraphStyle(
        'TableHeader',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=8,
        leading=10,
        textColor=colors.white
    )

    td_bold = ParagraphStyle(
        'TableBold',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=7.5,
        leading=9.5,
        textColor=c_primary
    )

    td_style = ParagraphStyle(
        'TableCell',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=7.5,
        leading=9.5,
        textColor=c_dark
    )

    story = []

    def make_callout(text, bg=c_callout_bg, border=c_callout_border, title="Design Principle"):
        p_title = Paragraph(f"<b>{title}</b>", ParagraphStyle('CalloutT', fontName='Helvetica-Bold', fontSize=8.5, leading=11, textColor=border))
        p_body = Paragraph(text, ParagraphStyle('CalloutB', fontName='Helvetica', fontSize=8, leading=11, textColor=c_dark))
        t = Table([[p_title], [p_body]], colWidths=[504])
        t.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), bg),
            ('BOX', (0,0), (-1,-1), 1, border),
            ('LEFTPADDING', (0,0), (-1,-1), 8),
            ('RIGHTPADDING', (0,0), (-1,-1), 8),
            ('TOPPADDING', (0,0), (-1,-1), 4),
            ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ]))
        return t

    # ==================================================================
    # PAGE 1: TITLE, TEAM & PROJECT OVERVIEW
    # ==================================================================
    story.append(Paragraph("CodeBox: Master Technical &amp; Systems Defense Guide", title_style))
    story.append(Paragraph("Containerized Execution Engine, OS Concurrency, Strict 3NF Relational Storage &amp; Automated Online Judge", subtitle_style))
    story.append(HRFlowable(width="100%", thickness=1.5, color=c_primary, spaceBefore=2, spaceAfter=8))

    # Team & Credentials Table
    team_data = [
        [Paragraph("<b>Academic Project &amp; Team Portfolio</b>", th_style), Paragraph("<b>Core Architecture Specifications</b>", th_style)],
        [
            Paragraph("<b>Team ID:</b> ayush908828 | <b>Degree:</b> B.Tech CSE<br/>"
                      "<b>1. Ayush Negi (Lead)</b> (Roll: 2418394, ID: 240111265)<br/>"
                      "<b>2. Dhruv Bhatt</b> (Roll: 2418455, ID: 240211470)<br/>"
                      "<b>3. Devansh Joshi</b> (Roll: 2418442, ID: 240211468)<br/>"
                      "<b>4. Dibyanshu Negi</b> (Roll: 2418461, ID: 240111185)<br/>"
                      "<b>5. Kartik Rawat</b> (Roll: 2418578, ID: 240111227)", td_style),
            Paragraph("<b>Execution Model:</b> Ephemeral Docker Sandboxes with kernel cgroups<br/>"
                      "<b>Concurrency:</b> 3-Worker FCFS Thread Pool via std::condition_variable<br/>"
                      "<b>Database:</b> SQLite3 Strict 3NF, WAL Mode, Foreign Keys<br/>"
                      "<b>Languages Supported:</b> C (GCC), C++17, Python 3, Java 17<br/>"
                      "<b>Security Limits:</b> 256MB RAM ceiling, 2.0s SIGKILL watchdog", td_style)
        ]
    ]
    t_team = Table(team_data, colWidths=[252, 252])
    t_team.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('BACKGROUND', (0,1), (-1,-1), colors.HexColor("#F8FAFC")),
    ]))
    story.append(t_team)
    story.append(Spacer(1, 8))

    story.append(Paragraph("1. Project Overview &amp; Architectural Purpose", h1_style))
    story.append(Paragraph(
        "<b>Technical Definition:</b> CodeBox is a containerized code execution, process isolation, and hardware resource metering platform. "
        "It provides the core backend computational engine required by competitive programming platforms (such as LeetCode and Codeforces) "
        "and automated technical assessment systems.<br/><br/>"
        "<b>Dual-Mode User Experience:</b> The platform delivers a dual workflow: (1) <i>Practice Questions</i> offering algorithmic problem-solving with automated multi-case evaluation, "
        "and (2) <i>Coding Platform</i> offering an unrestricted, multi-file code editor (supporting C, C++, Python, and Java) with standard input streaming and integrated terminal output. "
        "At the infrastructure level, untrusted user code (including memory leaks, fork bombs, and infinite loops) is completely quarantined inside "
        "an ephemeral Docker sandbox, safeguarding the host operating system.<br/><br/>"
        "<b>Crowdsourced Question Authoring:</b> Instructors and platform users can dynamically author new algorithmic problems with custom input/output test suites, "
        "which are validated and persisted into the relational catalog without requiring platform redeployment.",
        body_style
    ))
    story.append(Spacer(1, 4))

    restaurant_analogy = (
        "<b>The Analogy:</b> Imagine a patron enters a restaurant and requests: 'Allow me into your kitchen to cook my own food.' "
        "Granting them direct access to the main kitchen risks equipment damage, gas leaks, and fire hazards.<br/>"
        "<b>The Solution:</b> Instead, the restaurant places the patron in an isolated cooking booth equipped exclusively with one induction stove, "
        "one pan, and a hard 2-minute power cut-off timer. This is precisely how CodeBox isolates untrusted code using Docker namespaces, "
        "cgroups memory ceilings (256MB), and kernel watchdog timers (2.0s SIGKILL)."
    )
    story.append(make_callout(restaurant_analogy, title="Real-World Analogical Defense (Restaurant Kitchen Model)"))

    # ==================================================================
    # PAGE 2: OPERATING SYSTEM CORE MODULES
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("2. Operating System (OS) Core Modules &amp; Low-Level Primitives", h1_style))
    story.append(Paragraph(
        "CodeBox leverages five foundational Linux operating system mechanisms to enforce process sandboxing and real-time telemetry metering:",
        body_style
    ))

    os_table_data = [
        [Paragraph("<b>OS Primitive</b>", th_style), Paragraph("<b>Kernel Mechanism</b>", th_style), Paragraph("<b>CodeBox Implementation &amp; Defense Logic</b>", th_style)],
        [
            Paragraph("<b>Process Isolation (Namespaces)</b>", td_bold),
            Paragraph("Linux Kernel Namespaces (<code>pid</code>, <code>net</code>, <code>mnt</code>, <code>ipc</code>, <code>uts</code>).", td_style),
            Paragraph("Quarantines processes into isolated virtualization contexts. Untrusted user code cannot inspect host processes, reach host networks, or tamper with the host filesystem.", td_style)
        ],
        [
            Paragraph("<b>Resource Metering (cgroups)</b>", td_bold),
            Paragraph("Linux Control Groups (<code>cgroups v2</code>).", td_style),
            Paragraph("Enforces a hard ceiling of <b>256MB RAM</b>. Exceeding this limit causes the kernel Out-Of-Memory (OOM) killer to instantly terminate the container with exit code 137.", td_style)
        ],
        [
            Paragraph("<b>Process Lifecycle (fork / execve)</b>", td_bold),
            Paragraph("POSIX <code>fork()</code> and <code>execve()</code> system calls.", td_style),
            Paragraph("The C++ master daemon spawns isolated child execution processes inside dedicated namespaces, preventing user code crashes from destabilizing the parent HTTP server.", td_style)
        ],
        [
            Paragraph("<b>Watchdog Signals (SIGKILL)</b>", td_bold),
            Paragraph("POSIX <code>SIGKILL</code> (Signal 9) via execution watchdog.", td_style),
            Paragraph("If untrusted code enters an infinite loop (e.g., <code>while(true)</code>), a 2.0-second timer expires and the OS immediately kills the process, returning exit code 124 (TLE).", td_style)
        ],
        [
            Paragraph("<b>I/O Redirection (Pipes)</b>", td_bold),
            Paragraph("POSIX <code>pipe()</code> and standard stream file descriptors.", td_style),
            Paragraph("Standard streams (<code>stdin</code>, <code>stdout</code>, <code>stderr</code>) are redirected between container boundaries to supply test inputs and capture execution logs.", td_style)
        ],
    ]
    t_os = Table(os_table_data, colWidths=[105, 125, 274])
    t_os.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_os)
    story.append(Spacer(1, 8))

    story.append(Paragraph("3. Comprehensive Database Architecture (Strict 3NF Schema)", h1_style))
    story.append(Paragraph(
        "The relational storage tier is modeled in Third Normal Form (3NF) to eliminate data redundancy and prevent update/deletion anomalies:",
        body_style
    ))

    db_table_data = [
        [Paragraph("<b>Relation</b>", th_style), Paragraph("<b>Key Attributes &amp; Constraints</b>", th_style), Paragraph("<b>Relational Role &amp; 3NF Integrity</b>", th_style)],
        [
            Paragraph("<b><code>users</code></b>", td_bold),
            Paragraph("<code>user_id</code> (PK), <code>username</code> (UNIQUE, NOCASE), <code>email</code> (UNIQUE, NOCASE), <code>password_hash</code>, <code>created_at</code>", td_style),
            Paragraph("Stores user identity and credentials. The <code>NOCASE</code> collation enforces case-insensitive uniqueness, preventing duplicate account vulnerabilities.", td_style)
        ],
        [
            Paragraph("<b><code>difficulties</code></b>", td_bold),
            Paragraph("<code>difficulty_id</code> (PK), <code>label</code> ('Easy', 'Medium', 'Hard'), <code>points</code> (10, 20, 30)", td_style),
            Paragraph("Lookup table. Eliminates transitive dependency (<code>problem -> difficulty -> points</code>), ensuring points depend strictly on difficulty level.", td_style)
        ],
        [
            Paragraph("<b><code>categories</code></b>", td_bold),
            Paragraph("<code>category_id</code> (PK), <code>name</code> (UNIQUE ['Arrays', 'Strings', 'DP', 'Trees', etc.])", td_style),
            Paragraph("Normalizes algorithmic topic taxonomies, avoiding unbounded string repetition across problem entities.", td_style)
        ],
        [
            Paragraph("<b><code>languages</code></b>", td_bold),
            Paragraph("<code>language_id</code> (PK), <code>name</code> ('c', 'cpp', 'python', 'java'), <code>docker_image</code>", td_style),
            Paragraph("Decouples runtime environments from problem configurations. Maps languages to container images (`gcc:latest`, `python:3`, `openjdk:17`).", td_style)
        ],
        [
            Paragraph("<b><code>problems</code></b>", td_bold),
            Paragraph("<code>problem_id</code> (PK), <code>title</code>, <code>slug</code> (UNIQUE), <code>difficulty_id</code> (FK), <code>category_id</code> (FK), <code>starter_c</code>, <code>starter_cpp</code>, ...", td_style),
            Paragraph("Core problem entity storing problem text, asymptotic constraints, and compilable starter boilerplate reading from <code>stdin</code>.", td_style)
        ],
        [
            Paragraph("<b><code>test_cases</code></b>", td_bold),
            Paragraph("<code>testcase_id</code> (PK), <code>problem_id</code> (FK ON DELETE CASCADE), <code>input_data</code>, <code>expected_output</code>, <code>is_sample</code>", td_style),
            Paragraph("Normalized 1-to-N relation. Distinguishes public sample cases (<code>is_sample=1</code>) from private hidden judge cases (<code>is_sample=0</code>).", td_style)
        ],
        [
            Paragraph("<b><code>submissions</code></b>", td_bold),
            Paragraph("<code>submission_id</code> (PK), <code>user_id</code> (FK), <code>problem_id</code> (FK), <code>verdict</code>, <code>execution_time_ms</code>, <code>memory_used_kb</code>, <code>passed_cases</code>", td_style),
            Paragraph("Immutable submission audit trail. Captures judge verdicts, wall-clock time in ms, cgroups memory consumption, and pass ratios.", td_style)
        ],
    ]
    t_db = Table(db_table_data, colWidths=[90, 160, 254])
    t_db.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_db)

    # ==================================================================
    # PAGE 3: EMBEDDED SYSTEM ALGORITHMS & TEST CASE STRATEGY
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("4. Embedded System Algorithms &amp; Concurrency Control", h1_style))
    story.append(Paragraph(
        "Critical algorithmic techniques deployed across the API, concurrency, and evaluation tiers:",
        body_style
    ))

    algo_table_data = [
        [Paragraph("<b>Algorithm / Primitive</b>", th_style), Paragraph("<b>Subsystem Layer</b>", th_style), Paragraph("<b>Operational Mechanism &amp; Purpose</b>", th_style)],
        [
            Paragraph("<b>Token Bucket / Rate Limiter</b>", td_bold),
            Paragraph("API Gateway / Middleware", td_style),
            Paragraph("Enforces per-client rate limiting (e.g., maximum 5 submissions/minute) to mitigate Denial-of-Service (DoS) attacks.", td_style)
        ],
        [
            Paragraph("<b>FCFS Thread Pool (QueueScheduler)</b>", td_bold),
            Paragraph("C++ Execution Core", td_style),
            Paragraph("Maintains 3 persistent worker threads using <code>std::mutex</code> and <code>std::condition_variable</code> for zero-CPU-burn request queueing.", td_style)
        ],
        [
            Paragraph("<b>Myers Diff &amp; Whitespace Trimmer</b>", td_bold),
            Paragraph("ResultEvaluator", td_style),
            Paragraph("Sanitizes trailing spaces, tabs, and CRLF (<code>\\r\\n</code>) terminators prior to string matching, eliminating cross-platform newline artifacts.", td_style)
        ],
        [
            Paragraph("<b>Write-Ahead Logging (WAL)</b>", td_bold),
            Paragraph("SQLite3 Storage Engine", td_style),
            Paragraph("Appends transactions to an auxiliary WAL log file, allowing concurrent readers to execute without blocking writers.", td_style)
        ],
        [
            Paragraph("<b>Linux /proc Telemetry Accounting</b>", td_bold),
            Paragraph("OS Monitoring Engine", td_style),
            Paragraph("Polls kernel <code>/proc/[pid]/stat</code> and cgroups memory counters to compute millisecond-accurate execution time and memory usage.", td_style)
        ],
    ]
    t_algo = Table(algo_table_data, colWidths=[120, 110, 274])
    t_algo.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_algo)
    story.append(Spacer(1, 8))

    story.append(Paragraph("5. Critical Technical Doubts &amp; Edge-Case Testing Strategy", h1_style))
    story.append(Paragraph(
        "<b>Doubt 1: What if a student implements an entirely invented or unconventional algorithm? How do test cases validate it?</b><br/>"
        "<i>Fundamental Principle:</i> Test cases evaluate the <b>Problem Specification</b>, not the internal algorithmic approach! "
        "For example, given the 'Two Sum' problem with target 9 and array <code>[2, 7, 11, 15]</code>, the expected standard output is <code>[0, 1]</code>. "
        "Whether a student implements a brute-force approach, a hash map lookup, or a two-pointer technique, as long as the program produces "
        "the correct output on <code>stdout</code> within 2.0 seconds and 256MB RAM, the system marks the solution <b>Accepted</b>.",
        body_style
    ))
    story.append(Spacer(1, 4))

    story.append(Paragraph(
        "<b>Doubt 2: Optimal ~10 Test Cases Tiering Structure</b><br/>"
        "To maximize evaluation rigor without introducing excessive container dispatch latency, test suites are partitioned into three tiers:<br/>"
        "<b>1. Public Sample Test Cases (2 Cases):</b> Visible in the UI for rapid algorithmic comprehension and dry-run validation.<br/>"
        "<b>2. Hidden Standard Test Cases (3-4 Cases):</b> Evaluates regular non-trivial inputs, branch conditions, and nominal workloads.<br/>"
        "<b>3. Critical Boundary &amp; Edge Test Cases (4-5 Cases):</b> Stress-tests extreme corner scenarios:<br/>"
        "&nbsp;&nbsp;&bull; <i>Boundary Extremes:</i> Max integer bounds ($2^{31}-1$), negative inputs, and empty arrays.<br/>"
        "&nbsp;&nbsp;&bull; <i>Asymptotic Time Stress:</i> Maximum input bounds ($N = 10^5$) to trigger Time Limit Exceeded ($TLE$) on suboptimal $O(n^2)$ code.<br/>"
        "&nbsp;&nbsp;&bull; <i>Memory Stress:</i> High-volume allocation testing cgroups 256MB ceiling to identify memory leaks.<br/>"
        "&nbsp;&nbsp;&bull; <i>Pattern Extremes:</i> All-duplicate elements, strictly sorted arrays, and reverse-sorted arrays.",
        body_style
    ))

    # ==================================================================
    # PAGE 4: PLATFORM COMPARISON & MASTER DEFENSE STATEMENT
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("6. Platform Comparison: VS Code vs LeetCode vs CodeBox", h1_style))
    story.append(Paragraph(
        "Architectural comparison contrasting CodeBox against conventional coding sandboxes and commercial platforms:",
        body_style
    ))

    comp_table_data = [
        [Paragraph("<b>Evaluation Dimension</b>", th_style), Paragraph("<b>LeetCode</b>", th_style), Paragraph("<b>VS Code (Local)</b>", th_style), Paragraph("<b>CodeBox (Our Platform)</b>", th_style)],
        [
            Paragraph("<b>Core Focus &amp; Purpose</b>", td_bold),
            Paragraph("Fixed interview practice catalog only; cannot run arbitrary multi-file programs.", td_style),
            Paragraph("Local developer IDE; lacks automated judge evaluation test suites.", td_style),
            Paragraph("<b>Hybrid Architecture:</b> LeetCode-style algorithmic judging combined with an open, multi-language coding studio.", td_style)
        ],
        [
            Paragraph("<b>Problem Authoring</b>", td_bold),
            Paragraph("Proprietary; ordinary users cannot author or publish problems.", td_style),
            Paragraph("No concept of problem creation or test case verification.", td_style),
            Paragraph("<b>Crowdsourced Authoring:</b> Instructors and developers can author and publish custom problems with test suites.", td_style)
        ],
        [
            Paragraph("<b>Hardware Telemetry</b>", td_bold),
            Paragraph("Approximated runtime percentiles; internal hardware telemetry hidden.", td_style),
            Paragraph("Unmetered local execution; lacks memory ceiling or watchdog timers.", td_style),
            Paragraph("<b>Granular Kernel Telemetry:</b> Tracks millisecond wall-clock time, cgroups memory consumption, and pass ratios.", td_style)
        ],
        [
            Paragraph("<b>Execution Security</b>", td_bold),
            Paragraph("Cloud sandbox (remote execution).", td_style),
            Paragraph("Local machine (runs directly on host OS without sandboxing).", td_style),
            Paragraph("<b>Isolated Ephemeral Docker Sandbox:</b> Host is 100% secure with 256MB RAM cap, no network, and 2.0s SIGKILL watchdog.", td_style)
        ],
        [
            Paragraph("<b>Database &amp; Data Model</b>", td_bold),
            Paragraph("Proprietary distributed database.", td_style),
            Paragraph("None (local file storage).", td_style),
            Paragraph("<b>Strict 3NF SQLite Database:</b> 7 normalized tables, WAL mode concurrency, zero transitive dependencies.", td_style)
        ],
    ]
    t_comp = Table(comp_table_data, colWidths=[90, 134, 134, 146])
    t_comp.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_comp)
    story.append(Spacer(1, 10))

    master_statement = (
        "<b>External Examiner Presentation Pitch:</b><br/>"
        "<i>'Sir, commercial platforms like LeetCode restrict users to fixed problem sets without arbitrary code execution, "
        "while local IDEs like VS Code lack automated multi-case evaluation and process jailing. "
        "CodeBox provides a production-grade hybrid architecture: it pairs open multi-language development with automated algorithmic judging, "
        "enforces process isolation via Linux kernel cgroups (256MB) and watchdog timeouts (2.0s SIGKILL), and maintains transactional integrity "
        "using a Third Normal Form (3NF) relational database.'</i>"
    )
    story.append(make_callout(master_statement, title="Master Presentation & Defense Statement"))
    story.append(Spacer(1, 8))

    story.append(Paragraph("7. Pre-Defense Verification Matrix", h1_style))
    checklist_data = [
        [Paragraph("<b>Subsystem</b>", th_style), Paragraph("<b>Verification Status</b>", th_style), Paragraph("<b>Verification Command &amp; Evidence</b>", th_style)],
        [
            Paragraph("<b>Strict 3NF Database</b>", td_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED</b></font>", td_style),
            Paragraph("7 normalized tables; lookup tables for difficulties, categories, languages; zero transitive dependencies.", td_style)
        ],
        [
            Paragraph("<b>30+ DSA Problems</b>", td_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED</b></font>", td_style),
            Paragraph("30 problems seeded with working C, C++, Python, Java starters and sample/hidden test cases.", td_style)
        ],
        [
            Paragraph("<b>Multi-Test Judge</b>", td_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED</b></font>", td_style),
            Paragraph("ResultEvaluator with trailing whitespace trimming & CRLF normalization; AC, WA, TLE, MLE, CE, RE.", td_style)
        ],
        [
            Paragraph("<b>Thread Pool Scheduler</b>", td_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED</b></font>", td_style),
            Paragraph("QueueScheduler with 3 FCFS worker threads, std::mutex, std::condition_variable, zero busy-waiting.", td_style)
        ],
        [
            Paragraph("<b>Docker Sandbox Jailing</b>", td_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED</b></font>", td_style),
            Paragraph("DockerSandbox enforcing 256MB RAM cap, 2.0s SIGKILL watchdog, and --network none isolation.", td_style)
        ],
        [
            Paragraph("<b>Full C (GCC) Support</b>", td_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED</b></font>", td_style),
            Paragraph("gcc -O2 main.c -o main, starter_c column in DB, C tab in Coding Platform Monaco editor.", td_style)
        ],
        [
            Paragraph("<b>Mandatory Login Gate</b>", td_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED</b></font>", td_style),
            Paragraph("Zero-guest security. Non-dismissible full-screen modal until authentication.", td_style)
        ],
    ]
    t_check = Table(checklist_data, colWidths=[120, 90, 294])
    t_check.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_check)

    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"[Success] Master English CodeBox.pdf generated at: {output_path}")

if __name__ == "__main__":
    out_pdf = os.path.join(os.getcwd(), "DETAILS", "CodeBox.pdf")
    build_codebox_pdf(out_pdf)
