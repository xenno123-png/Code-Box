#!/usr/bin/env python3
"""
CodeBox Phase 3: Systems & Defense Manual Generator
Generates DETAILS/CodeBox_Phase3.pdf using ReportLab 5.0.1
Includes NumberedCanvas for dynamic 'Page X of Y' and professional headers/footers.
Deep, exhaustive Hinglish explanations for B.Tech CSE project defense.
"""

import os
import sys
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, HRFlowable
)
from reportlab.pdfgen import canvas

# ----------------------------------------------------------------------
# 1. Numbered Canvas for Dynamic "Page X of Y" & Running Headers
# ----------------------------------------------------------------------
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
        if self._pageNumber == 1:
            # Suppress header and footer on cover page
            return

        self.saveState()
        self.setFont("Helvetica-Bold", 8)
        self.setFillColor(colors.HexColor("#64748B"))

        # Running Top Header
        self.drawString(54, letter[1] - 36, "CODEBOX v3.0 — FULL-STACK ONLINE CODING & JUDGE PLATFORM")
        self.setFont("Helvetica", 8)
        self.drawRightString(letter[0] - 54, letter[1] - 36, "Phase 3 Systems & Defense Manual")

        # Top rule
        self.setStrokeColor(colors.HexColor("#CBD5E1"))
        self.setLineWidth(0.75)
        self.line(54, letter[1] - 42, letter[0] - 54, letter[1] - 42)

        # Running Bottom Footer
        self.line(54, 45, letter[0] - 54, 45)
        self.setFont("Helvetica", 8)
        self.drawString(54, 32, "B.Tech CSE Project Proposal & Systems Defense | Team: ayush908828")
        page_str = f"Page {self._pageNumber} of {page_count}"
        self.drawRightString(letter[0] - 54, 32, page_str)
        self.restoreState()


# ----------------------------------------------------------------------
# 2. Main PDF Generation Function
# ----------------------------------------------------------------------
def build_phase3_pdf(output_path):
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

    # Custom Palette
    c_primary = colors.HexColor("#1E3A8A")     # Dark Blue
    c_secondary = colors.HexColor("#0D9488")   # Teal
    c_dark = colors.HexColor("#0F172A")        # Slate 900
    c_body = colors.HexColor("#334155")        # Slate 700
    c_bg_code = colors.HexColor("#1E293B")     # Dark code box
    c_callout_bg = colors.HexColor("#F0FDF4")  # Soft Green
    c_callout_border = colors.HexColor("#16A34A")
    c_note_bg = colors.HexColor("#EFF6FF")     # Soft Blue
    c_note_border = colors.HexColor("#2563EB")
    c_viva_bg = colors.HexColor("#FEF2F2")     # Soft Red/Amber
    c_viva_border = colors.HexColor("#DC2626")

    # Custom Typography Styles
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=24,
        leading=28,
        textColor=c_primary,
        alignment=0, # Left
        spaceAfter=8
    )

    subtitle_style = ParagraphStyle(
        'DocSubTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=13,
        leading=17,
        textColor=c_secondary,
        alignment=0,
        spaceAfter=15
    )

    h1_style = ParagraphStyle(
        'Header1',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=15,
        leading=19,
        textColor=c_primary,
        spaceBefore=14,
        spaceAfter=8,
        keepWithNext=True
    )

    h2_style = ParagraphStyle(
        'Header2',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=12,
        leading=16,
        textColor=c_dark,
        spaceBefore=10,
        spaceAfter=6,
        keepWithNext=True
    )

    body_style = ParagraphStyle(
        'BodyTextCustom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9.5,
        leading=13.5,
        textColor=c_body,
        spaceAfter=6
    )

    bullet_style = ParagraphStyle(
        'BulletCustom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9.5,
        leading=13.5,
        textColor=c_body,
        leftIndent=15,
        firstLineIndent=-10,
        spaceAfter=4
    )

    code_style = ParagraphStyle(
        'CodeSnippet',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=8,
        leading=11,
        textColor=colors.HexColor("#E2E8F0")
    )

    table_header_style = ParagraphStyle(
        'TableHeader',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=8.5,
        leading=11,
        textColor=colors.white
    )

    table_cell_style = ParagraphStyle(
        'TableCell',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8,
        leading=11,
        textColor=c_dark
    )

    table_cell_bold = ParagraphStyle(
        'TableCellBold',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=8,
        leading=11,
        textColor=c_primary
    )

    viva_q_style = ParagraphStyle(
        'VivaQ',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=9.5,
        leading=13,
        textColor=colors.HexColor("#991B1B"),
        spaceBefore=4,
        spaceAfter=2,
        keepWithNext=True
    )

    viva_ans_style = ParagraphStyle(
        'VivaAns',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9,
        leading=12.5,
        textColor=colors.HexColor("#1E293B"),
        spaceAfter=6
    )

    story = []

    def make_callout(text, bg=c_note_bg, border=c_note_border, title="Bhai Dhyan Se Samjho (Core Concept)"):
        p_title = Paragraph(f"<b>{title}</b>", ParagraphStyle('CalloutT', fontName='Helvetica-Bold', fontSize=9, leading=12, textColor=border))
        p_body = Paragraph(text, ParagraphStyle('CalloutB', fontName='Helvetica', fontSize=8.5, leading=12, textColor=c_dark))
        t = Table([[p_title], [p_body]], colWidths=[504])
        t.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), bg),
            ('BOX', (0,0), (-1,-1), 1, border),
            ('LEFTPADDING', (0,0), (-1,-1), 10),
            ('RIGHTPADDING', (0,0), (-1,-1), 10),
            ('TOPPADDING', (0,0), (-1,-1), 6),
            ('BOTTOMPADDING', (0,0), (-1,-1), 6),
        ]))
        return t

    def make_code_box(code_text):
        escaped = code_text.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
        p = Paragraph(f"<pre>{escaped}</pre>", code_style)
        t = Table([[p]], colWidths=[504])
        t.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), c_bg_code),
            ('LEFTPADDING', (0,0), (-1,-1), 8),
            ('RIGHTPADDING', (0,0), (-1,-1), 8),
            ('TOPPADDING', (0,0), (-1,-1), 6),
            ('BOTTOMPADDING', (0,0), (-1,-1), 6),
            ('BOX', (0,0), (-1,-1), 1, colors.HexColor("#334155")),
        ]))
        return t

    # ==================================================================
    # PAGE 1: TITLE & TEAM PORTFOLIO
    # ==================================================================
    story.append(Paragraph("B.Tech Computer Science &amp; Engineering | Project Defense", ParagraphStyle('SubSub', fontName='Helvetica-Bold', fontSize=10, textColor=c_secondary, spaceAfter=4)))
    story.append(Paragraph("CodeBox: Complete Phase 3 Systems Manual", title_style))
    story.append(Paragraph("Full-Stack Online Coding &amp; Multi-Test-Case Judge Platform — Deep Architecture, Relational 3NF Database, Multi-Language Sandbox, and Viva Defense Guide", subtitle_style))
    story.append(HRFlowable(width="100%", thickness=2, color=c_primary, spaceBefore=4, spaceAfter=14))

    # Team Box
    team_data = [
        [Paragraph("<b>Student / Team Information</b>", table_header_style), Paragraph("<b>Academic Credentials</b>", table_header_style)],
        [Paragraph("<b>Team Name:</b> ayush908828<br/><b>Project:</b> CodeBox (Phase 3 Full-Stack Platform)", table_cell_style),
         Paragraph("<b>Degree:</b> B.Tech Computer Science &amp; Engineering<br/><b>Engine:</b> C++17, Docker, SQLite3 (3NF), Monaco SPA", table_cell_style)],
        [Paragraph("<b>1. Ayush Negi (Team Lead)</b><br/>Uni Roll: 2418394 | Student ID: 240111265<br/>Email: ayush908828@gmail.com", table_cell_style),
         Paragraph("<b>2. Dhruv Bhatt</b><br/>Uni Roll: 2418455 | Student ID: 240211470<br/>Email: dhruvbhatt6396@gmail.com", table_cell_style)],
        [Paragraph("<b>3. Devansh Joshi</b><br/>Uni Roll: 2418442 | Student ID: 240211468<br/>Email: devansh2420@gmail.com", table_cell_style),
         Paragraph("<b>4. Dibyanshu Negi</b><br/>Uni Roll: 2418461 | Student ID: 240111185<br/>Email: negid0925@gmail.com", table_cell_style)],
        [Paragraph("<b>5. Kartik Rawat</b><br/>Uni Roll: 2418578 | Student ID: 240111227<br/>Email: kr9475837@gmail.com", table_cell_style),
         Paragraph("<b>Project Status:</b> Production Ready &amp; Fully Containerized<br/><b>Target Date:</b> November 2026", table_cell_style)],
    ]
    t_team = Table(team_data, colWidths=[252, 252])
    t_team.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('BACKGROUND', (0,1), (-1,-1), colors.HexColor("#F8FAFC")),
    ]))
    story.append(t_team)
    story.append(Spacer(1, 12))

    story.append(Paragraph("Executive Overview: Phase 2 Se Phase 3 Ka Evolutionary Leap", h2_style))
    story.append(Paragraph(
        "<b>Bhai Dhyan Se Suno:</b> Phase 2 mein humne ek solid OS-level containerized code execution engine develop kiya tha jisme 3 FCFS worker threads (<code>QueueScheduler</code>), Docker isolation (<code>256MB RAM</code>, <code>2.0s SIGKILL timeout</code>), aur basic playground execution thi. Lekin Phase 2 online judge nahi tha — wahan na koi database thi, na persistent users the, na problem catalog tha, aur na hi automatic multi-test-case validation thi.<br/><br/>"
        "<b>Phase 3</b> ne pure system ko transform karke ek enterprise-grade <b>Full-Stack Online Coding &amp; Judge Platform</b> bana diya hai: "
        "<b>(1)</b> Strict 3NF Relational SQLite3 Database jisme 7 fully normalized tables hain, "
        "<b>(2)</b> 30+ DSA Problems with C (GCC), C++17, Python 3, aur Java 17 starter codes aur sample + hidden test cases, "
        "<b>(3)</b> Multi-Test-Case Automated Online Judge jo code ko hidden test cases pe evaluate karke Accepted, Wrong Answer, TLE, ya CE deta hai, "
        "<b>(4)</b> Strict Mandatory Authentication Gate bina kisi guest leakage ke, aur "
        "<b>(5)</b> Modular Architecture with clean <code>frontend/</code>, <code>database/</code>, aur <code>backend/</code> separation and mouse-draggable split-pane resizers in Monaco Editor.",
        body_style
    ))
    story.append(Spacer(1, 8))

    callout_p1 = (
        "<b>Viva Secret:</b> Evaluator jab puche ki 'Phase 2 aur Phase 3 mein kya fundamental difference hai?', to seedhe bolna: "
        "'Sir, Phase 2 sirf ek Code Execution Engine tha jo ek request leke Docker mein execute karta tha. Phase 3 ek complete Online Judge &amp; Problem Solving Ecosystem hai jisme Relational 3NF DBMS, User Authentication, 30+ Problem Catalog, Multi-Test-Case Evaluation Engine, aur Draggable Monaco SPA shamil hai.'"
    )
    story.append(make_callout(callout_p1, bg=c_callout_bg, border=c_callout_border, title="Golden Defense Rule"))

    # ==================================================================
    # PAGE 2: ARCHITECTURE & FOLDER ORGANIZATION
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("1. Modular Folder Architecture &amp; System Flow", h1_style))
    story.append(Paragraph(
        "Industry-standard production software engineering mein code base ko tightly coupled monolithic files mein nahi rakha jata. "
        "Humne CodeBox ko 3 clean dedicated folders mein segregate kiya hai taaki concern separation (SoC - Separation of Concerns) achieve ho:",
        body_style
    ))

    folder_table_data = [
        [Paragraph("<b>Directory</b>", table_header_style), Paragraph("<b>Key Files Contained</b>", table_header_style), Paragraph("<b>Exact Architectural Role</b>", table_header_style)],
        [
            Paragraph("<b><code>frontend/</code></b>", table_cell_bold),
            Paragraph("<code>front_end.html</code><br/><code>README.md</code>", table_cell_style),
            Paragraph("Single Page Application (SPA). Monaco Code Editor integrate karta hai, mandatory login gate manage karta hai, tabs switch karta hai, aur mouse drag resizers handle karta hai.", table_cell_style)
        ],
        [
            Paragraph("<b><code>database/</code></b>", table_cell_bold),
            Paragraph("<code>schema.sql</code><br/><code>seed_problems.sql</code><br/><code>queries.sql</code><br/><code>codebox.db</code>", table_cell_style),
            Paragraph("Relational Database Tier. Strict 3NF schema, 30 DSA problems ka seed data, performance indexes, aur WAL mode transactional SQLite3 engine store karta hai.", table_cell_style)
        ],
        [
            Paragraph("<b><code>backend/</code></b>", table_cell_bold),
            Paragraph("<code>main.cpp</code>, <code>ApiHandler</code><br/><code>DatabaseManager</code><br/><code>QueueScheduler</code><br/><code>DockerSandbox</code><br/><code>LanguageConfig</code><br/><code>ResultEvaluator</code>, <code>FileManager</code><br/><code>Headers.h</code>, <code>httplib.h</code>", table_cell_style),
            Paragraph("Core Systems Tier. C++17 REST API server, thread pool scheduler (3 workers), Docker cgroups sandbox wrapper, multi-test-case online judge evaluator, aur SQLite3 ORM layer.", table_cell_style)
        ],
        [
            Paragraph("<b>Root (<code>.</code>)</b>", table_cell_bold),
            Paragraph("<code>Makefile</code><br/><code>.gitignore</code><br/><code>codebox_server</code>", table_cell_style),
            Paragraph("Master build orchestration. Root <code>make</code> run karne par <code>backend/</code> ke sare C++ files compile hote hain aur <code>-Ibackend -lsqlite3</code> ke sath target link hota hai.", table_cell_style)
        ],
    ]
    t_folder = Table(folder_table_data, colWidths=[70, 154, 280])
    t_folder.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_folder)
    story.append(Spacer(1, 10))

    story.append(Paragraph("Complete End-to-End Execution Flowchart", h2_style))
    flow_diagram = (
        "[User in Browser (Monaco Editor)]\n"
        "           │ (HTTP POST /api/leetcode/submit with { user_id, problem_id, language, code })\n"
        "           ▼\n"
        "[httplib::Server on 0.0.0.0:8080] ──> Dispatches to ApiHandler::handleLeetCodeSubmit()\n"
        "           │\n"
        "           ├─> 1. DatabaseManager: SELECT * FROM test_cases WHERE problem_id = :id\n"
        "           │      (Returns 3+ test cases: Sample + Hidden)\n"
        "           │\n"
        "           ├─> 2. Loop Through Each Test Case:\n"
        "           │      │\n"
        "           │      ├─> QueueScheduler::pushTask() [FCFS Queue with std::mutex & cv]\n"
        "           │      │      Worker Thread picks up task -> calls DockerSandbox::execute()\n"
        "           │      │\n"
        "           │      ├─> DockerSandbox: docker run --rm -i --network none -m 256m ...\n"
        "           │      │      Watchdog: timeout -s KILL 2.0s\n"
        "           │      │\n"
        "           │      └─> ResultEvaluator::evaluateTestCase(stdout, expected_output, exitCode)\n"
        "           │             Normalizes trailing whitespace; checks AC / WA / TLE / RE\n"
        "           │             Agar koi test case fail hota hai -> loop breaks immediately!\n"
        "           │\n"
        "           ├─> 3. DatabaseManager: INSERT INTO submissions (...) [Records verdict & metrics]\n"
        "           │\n"
        "           └─> 4. JSON Response back to Frontend: { status: 'Accepted', passed: 3, total: 3 }"
    )
    story.append(make_code_box(flow_diagram))
    story.append(Spacer(1, 10))

    story.append(Paragraph(
        "<b>Har Step Ka Deep Matlab:</b> Jab user Monaco editor mein submit button press karta hai, to browser backend ko REST API request bhejta hai. Backend ka <code>DatabaseManager</code> us problem ke sare test cases SQLite database se fetch karta hai. Fir <code>QueueScheduler</code> ke 3 worker threads us code ko Docker container mein isolated environment mein run karte hain jahan RAM limit 256MB aur watchdog timeout exactly 2.0 seconds lock hota hai. <code>ResultEvaluator</code> output match karta hai, aur verdict database mein audit log ki tarah save ho jata hai.",
        body_style
    ))

    # ==================================================================
    # PAGE 3: STRICT 3NF DATABASE ARCHITECTURE
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("2. Strict 3NF Relational Database Model (SQLite3 Engine)", h1_style))
    story.append(Paragraph(
        "<b>Bhai Dhyan Se Samjho (Normalization Concept):</b> B.Tech CSE viva mein external examiner database normalization par sabse zyada sawal puchta hai. "
        "CodeBox Phase 3 database ko <b>Strict 3rd Normal Form (3NF)</b> mein design kiya gaya hai. Iska matlab kya hai?",
        body_style
    ))

    norm_steps = (
        "<b>1. First Normal Form (1NF):</b> Table ke har column mein atomic (indivisible) values hone chahiye. Koi repeating groups ya multi-valued attributes nahi ho sakte.<br/>"
        "<b>2. Second Normal Form (2NF):</b> Table pehle 1NF mein ho, aur har non-key attribute fully functionally dependent ho Composite Primary Key par (No partial dependency).<br/>"
        "<b>3. Third Normal Form (3NF):</b> Table pehle 2NF mein ho, aur koi bhi Transitive Dependency na ho (i.e. Non-key attribute kisi dusre non-key attribute par depend nahi kar sakta! X -> Y -> Z allowed nahi hai; sirf Primary Key decide karegi non-key attributes ko)."
    )
    story.append(make_callout(norm_steps, bg=c_callout_bg, border=c_callout_border, title="1NF vs 2NF vs 3NF Cheatsheet"))
    story.append(Spacer(1, 8))

    story.append(Paragraph("Humne 3NF Kaise Enforce Kiya? (Real Example)", h2_style))
    story.append(Paragraph(
        "Agar hum <code>problems</code> table ke andar hi <code>difficulty_name</code> ('Easy') aur <code>points</code> (10) dono store karte, to transitive dependency ban jati: "
        "<code>problem_id -> difficulty_name -> points</code>! Agar kal ko hum 'Easy' ke points 10 se 15 karte, to hume hazaron rows update karni padti (Update Anomaly). "
        "Isliye humne <b>Lookup Tables</b> create kiye: <code>difficulties</code>, <code>categories</code>, aur <code>languages</code>! "
        "Ab <code>problems</code> table sirf foreign keys store karta hai, eliminating all transitive dependencies!",
        body_style
    ))
    story.append(Spacer(1, 6))

    story.append(Paragraph("7 Normalized Tables Ka Complete Breakdown", h2_style))
    db_table_data = [
        [Paragraph("<b>Table Name</b>", table_header_style), Paragraph("<b>Columns &amp; Constraints</b>", table_header_style), Paragraph("<b>3NF Normalization Role</b>", table_header_style)],
        [
            Paragraph("<b><code>users</code></b>", table_cell_bold),
            Paragraph("<code>user_id</code> (PK, AUTOINCREMENT)<br/><code>username</code> (TEXT, UNIQUE, NOCASE)<br/><code>email</code> (TEXT, UNIQUE, NOCASE)<br/><code>password_hash</code> (TEXT)<br/><code>created_at</code> (DATETIME)", table_cell_style),
            Paragraph("User authentication table. NOCASE ensures unique collation so 'Alice' aur 'alice' duplicate na ho sakein.", table_cell_style)
        ],
        [
            Paragraph("<b><code>difficulties</code></b>", table_cell_bold),
            Paragraph("<code>difficulty_id</code> (PK)<br/><code>label</code> ('Easy', 'Medium', 'Hard')<br/><code>points</code> (10, 20, 30)", table_cell_style),
            Paragraph("3NF Lookup Table. Points exclusively difficulty par depend karte hain, zero transitive dependency.", table_cell_style)
        ],
        [
            Paragraph("<b><code>categories</code></b>", table_cell_bold),
            Paragraph("<code>category_id</code> (PK)<br/><code>name</code> (UNIQUE ['Arrays', 'Strings', 'DP', 'Trees', etc.])", table_cell_style),
            Paragraph("Normalized problem categorization lookup. Tag name repeat hone se bachata hai.", table_cell_style)
        ],
        [
            Paragraph("<b><code>languages</code></b>", table_cell_bold),
            Paragraph("<code>language_id</code> (PK)<br/><code>name</code> ('c', 'cpp', 'python', 'java')<br/><code>display_name</code>, <code>docker_image</code>", table_cell_style),
            Paragraph("Compiler &amp; container mapping lookup. Runtime images isolate karta hai.", table_cell_style)
        ],
        [
            Paragraph("<b><code>problems</code></b>", table_cell_bold),
            Paragraph("<code>problem_id</code> (PK)<br/><code>title</code>, <code>slug</code> (UNIQUE)<br/><code>description</code>, <code>constraints</code><br/><code>difficulty_id</code> (FK), <code>category_id</code> (FK)<br/><code>starter_c</code>, <code>starter_cpp</code>, <code>starter_python</code>, <code>starter_java</code>", table_cell_style),
            Paragraph("Problem statements and starter code templates for all 4 supported languages. Foreign keys strictly validated.", table_cell_style)
        ],
        [
            Paragraph("<b><code>test_cases</code></b>", table_cell_bold),
            Paragraph("<code>testcase_id</code> (PK)<br/><code>problem_id</code> (FK ON DELETE CASCADE)<br/><code>input_data</code>, <code>expected_output</code><br/><code>is_sample</code> (1 = Sample, 0 = Hidden)", table_cell_style),
            Paragraph("1-to-Many normalized test cases. Problems table se test data ko alag karke multi-test judge support karta hai.", table_cell_style)
        ],
        [
            Paragraph("<b><code>submissions</code></b>", table_cell_bold),
            Paragraph("<code>submission_id</code> (PK)<br/><code>user_id</code> (FK), <code>problem_id</code> (FK), <code>language_id</code> (FK)<br/><code>source_code</code>, <code>verdict</code>, <code>execution_time_ms</code>, <code>memory_used_kb</code>, <code>passed_cases</code>, <code>total_cases</code>", table_cell_style),
            Paragraph("Audit trail for code submissions. Evaluator metrics, execution time in milliseconds, and memory consumption in KB.", table_cell_style)
        ],
    ]
    t_dbtables = Table(db_table_data, colWidths=[75, 175, 254])
    t_dbtables.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_dbtables)

    # ==================================================================
    # PAGE 4: SQL QUERIES & DATABASE PRAGMAS
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("3. Production SQL Queries &amp; High-Concurrency SQLite3 Tuning", h1_style))
    story.append(Paragraph(
        "SQLite3 ko high-performance backend ke sath use karne ke liye humne specific low-level SQLite Pragmas activate kiye hain "
        "aur advanced SQL queries likhi hain jo zero lock contention ensure karti hain:",
        body_style
    ))

    pragmas_info = (
        "<b>1. PRAGMA foreign_keys = ON;</b><br/>"
        "SQLite mein default foreign keys OFF hoti hain! Humne server startup pe explicit ON kiya taaki agar koi invalid <code>problem_id</code> ya <code>user_id</code> pass ho, to database referential integrity violation error throw kare.<br/><br/>"
        "<b>2. PRAGMA journal_mode = WAL; (Write-Ahead Logging)</b><br/>"
        "Traditional rollback journal mein jab koi writer write karta hai, to poori database lock ho jati hai (readers block ho jate hain). "
        "<b>WAL mode</b> mein changes ek separate <code>.db-wal</code> file mein append hote hain, jisse <i>Concurrent Readers and Writers</i> ek sath operate kar sakte hain without blocking!<br/><br/>"
        "<b>3. PRAGMA busy_timeout = 5000;</b><br/>"
        "Agar do threads ek sath transaction start karein, to immediate 'database is locked' crash hone ke bajaye SQLite exactly 5000ms (5 seconds) tak wait karegi lock release hone ka."
    )
    story.append(make_callout(pragmas_info, bg=c_note_bg, border=c_note_border, title="Production SQLite Pragmas & Concurrency Tuning"))
    story.append(Spacer(1, 10))

    story.append(Paragraph("Core 3NF Production SQL Queries (`database/queries.sql`)", h2_style))
    story.append(Paragraph("<b>1. Leaderboard Ranking Query (Point Aggregation with Distinct Problem Solved):</b>", body_style))
    sql_leaderboard = (
        "SELECT \n"
        "    u.user_id,\n"
        "    u.username,\n"
        "    COUNT(DISTINCT s.problem_id) AS solved_count,\n"
        "    COALESCE(SUM(DISTINCT d.points), 0) AS total_score\n"
        "FROM users u\n"
        "LEFT JOIN submissions s ON u.user_id = s.user_id AND s.verdict = 'Accepted'\n"
        "LEFT JOIN problems p ON s.problem_id = p.problem_id\n"
        "LEFT JOIN difficulties d ON p.difficulty_id = d.difficulty_id\n"
        "GROUP BY u.user_id, u.username\n"
        "ORDER BY total_score DESC, solved_count DESC, u.created_at ASC;"
    )
    story.append(make_code_box(sql_leaderboard))
    story.append(Spacer(1, 6))

    story.append(Paragraph("<b>2. Problem Catalog Listing with User Solved Status (3NF JOIN &amp; Subquery):</b>", body_style))
    sql_catalog = (
        "SELECT \n"
        "    p.problem_id,\n"
        "    p.title,\n"
        "    p.slug,\n"
        "    d.label AS difficulty,\n"
        "    d.points,\n"
        "    c.name AS category,\n"
        "    EXISTS (\n"
        "        SELECT 1 FROM submissions s \n"
        "        WHERE s.problem_id = p.problem_id \n"
        "          AND s.user_id = :user_id \n"
        "          AND s.verdict = 'Accepted'\n"
        "    ) AS is_solved\n"
        "FROM problems p\n"
        "JOIN difficulties d ON p.difficulty_id = d.difficulty_id\n"
        "JOIN categories c ON p.category_id = c.category_id\n"
        "ORDER BY p.problem_id ASC;"
    )
    story.append(make_code_box(sql_catalog))
    story.append(Spacer(1, 6))

    story.append(Paragraph(
        "<b>Kyu Yeh Queries Viva Mein Impress Karengi?</b> "
        "Notice karo ki humne <code>EXISTS (SELECT 1 ...)</code> use kiya hai boolean flag ke liye jo short-circuit evaluation karta hai (pehli Accepted row milte hi return ho jata hai, pura table scan nahi karta). "
        "Leaderboard query mein <code>COALESCE</code> use kiya hai taaki naye users ka score NULL na dikhe balki 0 dikhe!",
        body_style
    ))

    # ==================================================================
    # PAGE 5: 30+ DSA PROBLEM SUITE & 4-LANGUAGE SUPPORT
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("4. 30+ DSA Problem Catalog &amp; 4-Language Compilers", h1_style))
    story.append(Paragraph(
        "CodeBox Phase 3 mein industry-standard 30+ LeetCode-style Data Structures &amp; Algorithms problems pre-seeded hain. "
        "Har ek question ke liye C++17, Python 3, Java 17, aur naye <b>C (GCC)</b> ke compilable starter templates available hain "
        "jo standard input (<code>stdin</code>) se read karte hain aur standard output (<code>stdout</code>) par print karte hain.",
        body_style
    ))

    problems_summary_data = [
        [Paragraph("<b>Category</b>", table_header_style), Paragraph("<b>Representative Problems Included</b>", table_header_style), Paragraph("<b>Algorithmic Concepts Tested</b>", table_header_style)],
        [
            Paragraph("<b>Arrays &amp; Two Pointers</b>", table_cell_bold),
            Paragraph("Two Sum, 3Sum, Container With Most Water, Best Time to Buy/Sell Stock, Trapping Rain Water", table_cell_style),
            Paragraph("Hash map lookups O(n), two-pointer convergence, prefix/suffix max arrays, greedy single-pass scanning.", table_cell_style)
        ],
        [
            Paragraph("<b>Strings &amp; Hashing</b>", table_cell_bold),
            Paragraph("Valid Anagram, Group Anagrams, Longest Substring Without Repeating Characters, Palindrome Number", table_cell_style),
            Paragraph("Frequency counting, sorting keys, sliding window with dynamic hash set, mathematical digit extraction.", table_cell_style)
        ],
        [
            Paragraph("<b>Binary Search</b>", table_cell_bold),
            Paragraph("Binary Search, Search in Rotated Sorted Array, Find Minimum in Rotated Sorted Array", table_cell_style),
            Paragraph("Logarithmic divide-and-conquer O(log n), modified midpoint comparisons, monotonicity checks.", table_cell_style)
        ],
        [
            Paragraph("<b>Stack &amp; Linked List</b>", table_cell_bold),
            Paragraph("Valid Parentheses, Daily Temperatures, Merge Two Sorted Lists, Reverse Linked List", table_cell_style),
            Paragraph("Monotonic stack, LIFO matching, pointer manipulation, dummy head node techniques.", table_cell_style)
        ],
        [
            Paragraph("<b>Dynamic Programming</b>", table_cell_bold),
            Paragraph("Climbing Stairs, Coin Change, Longest Increasing Subsequence, Edit Distance", table_cell_style),
            Paragraph("Optimal substructure, overlapping subproblems, memoization vs bottom-up tabulation.", table_cell_style)
        ],
        [
            Paragraph("<b>Trees &amp; Math</b>", table_cell_bold),
            Paragraph("Maximum Depth of Binary Tree, Invert Binary Tree, Roman to Integer", table_cell_style),
            Paragraph("Recursive tree traversal (DFS), queue-based level order (BFS), state transition parsing.", table_cell_style)
        ],
    ]
    t_probs = Table(problems_summary_data, colWidths=[90, 204, 210])
    t_probs.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_probs)
    story.append(Spacer(1, 10))

    story.append(Paragraph("4 Languages: Compilers, Flags &amp; Exact Sandbox Jailing Commands", h2_style))
    lang_config_data = [
        [Paragraph("<b>Language</b>", table_header_style), Paragraph("<b>File Name</b>", table_header_style), Paragraph("<b>Compilation Command</b>", table_header_style), Paragraph("<b>Execution Command &amp; Flags</b>", table_header_style)],
        [
            Paragraph("<b>C (GCC)</b>", table_cell_bold),
            Paragraph("<code>main.c</code>", table_cell_style),
            Paragraph("<code>gcc -O2 main.c -o main</code>", table_cell_style),
            Paragraph("<code>./main</code> (Optimized native binary)", table_cell_style)
        ],
        [
            Paragraph("<b>C++17</b>", table_cell_bold),
            Paragraph("<code>main.cpp</code>", table_cell_style),
            Paragraph("<code>g++ -std=c++17 -O2 main.cpp -o main</code>", table_cell_style),
            Paragraph("<code>./main</code> (Modern C++ STL enabled)", table_cell_style)
        ],
        [
            Paragraph("<b>Python 3</b>", table_cell_bold),
            Paragraph("<code>main.py</code>", table_cell_style),
            Paragraph("<i>None (Interpreted)</i>", table_cell_style),
            Paragraph("<code>python3 -u main.py</code> (<code>-u</code> disables buffering)", table_cell_style)
        ],
        [
            Paragraph("<b>Java 17</b>", table_cell_bold),
            Paragraph("<code>Solution.java</code>", table_cell_style),
            Paragraph("<code>javac Solution.java</code>", table_cell_style),
            Paragraph("<code>java Solution</code> (Synchronized class name)", table_cell_style)
        ],
    ]
    t_langs = Table(lang_config_data, colWidths=[65, 75, 174, 190])
    t_langs.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_langs)
    story.append(Spacer(1, 8))

    story.append(Paragraph(
        "<b>Khas Note on C Language Addition:</b> Humne Phase 3 mein C support add karne ke liye pure stack ko modify kiya: "
        "<b>(1)</b> <code>LanguageConfig.cpp</code> mein <code>'c'</code> language rules register kiye, "
        "<b>(2)</b> <code>database/schema.sql</code> mein <code>problems</code> table par <code>starter_c TEXT</code> add kiya, "
        "<b>(3)</b> <code>seed_problems.sql</code> mein 30 DSA questions ke liye standard C (<code>stdio.h</code>) starter code inject kiya, aur "
        "<b>(4)</b> Frontend Monaco Editor mein <code>C (GCC)</code> mode add kiya.",
        body_style
    ))

    # ==================================================================
    # PAGE 6: MULTI-TEST-CASE JUDGE & VERDICT EVALUATOR
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("5. Automated Multi-Test-Case Online Judge System", h1_style))
    story.append(Paragraph(
        "Traditional simple playgrounds sirf user ka single input run karke output print kar dete hain. "
        "Lekin ek asli <b>Online Judge (LeetCode / Codeforces style)</b> user ke solution ko multiple test cases (Sample + Hidden) par systematically test karta hai. "
        "Niche pura judge evaluation mechanism explain kiya gaya hai:",
        body_style
    ))

    judge_table_data = [
        [Paragraph("<b>Verdict Label</b>", table_header_style), Paragraph("<b>HTTP Code / Exit Code</b>", table_header_style), Paragraph("<b>Trigger Condition &amp; Exact Cause</b>", table_header_style)],
        [
            Paragraph("<b>Accepted (AC)</b>", table_cell_bold),
            Paragraph("Exit Code: <code>0</code>", table_cell_style),
            Paragraph("User code ne sare test cases (Sample + Hidden) par correctly execute kiya aur trimmed output expected output se 100% exact match hua.", table_cell_style)
        ],
        [
            Paragraph("<b>Wrong Answer (WA)</b>", table_cell_bold),
            Paragraph("Exit Code: <code>0</code>", table_cell_style),
            Paragraph("Code bina crash huye execute to ho gaya, lekin output expected output se match nahi hua (e.g. expected: <code>[0,1]</code>, actual: <code>[1,2]</code>).", table_cell_style)
        ],
        [
            Paragraph("<b>Time Limit Exceeded (TLE)</b>", table_cell_bold),
            Paragraph("Exit Code: <code>124</code>", table_cell_style),
            Paragraph("Linux <code>timeout</code> command ne process ko 2.0s ke baad <code>SIGKILL (signal 9)</code> bhej kar terminate kiya (Infinite loop ya O(n^2) algorithm timeout).", table_cell_style)
        ],
        [
            Paragraph("<b>Memory Limit Exceeded (MLE)</b>", table_cell_bold),
            Paragraph("Exit Code: <code>137</code>", table_cell_style),
            Paragraph("Docker daemon cgroups ne process ko 256MB memory cap cross karne par <code>OOM-killer (Out of Memory)</code> se kill kar diya.", table_cell_style)
        ],
        [
            Paragraph("<b>Compilation Error (CE)</b>", table_cell_bold),
            Paragraph("Compiler Exit: <code>!= 0</code>", table_cell_style),
            Paragraph("<code>gcc</code>, <code>g++</code>, ya <code>javac</code> fail ho gaya syntax error, missing semicolon, ya undefined symbol ki wajah se. Error log user ko display hota hai.", table_cell_style)
        ],
        [
            Paragraph("<b>Runtime Error (RE)</b>", table_cell_bold),
            Paragraph("Exit Code: <code>1, 139, etc.</code>", table_cell_style),
            Paragraph("Process crash ho gaya due to Segmentation Fault (SIGSEGV), Division by Zero (SIGFPE), ya unhandled exception (Python Traceback, Java NullPointerException).", table_cell_style)
        ],
    ]
    t_judge = Table(judge_table_data, colWidths=[100, 90, 314])
    t_judge.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_judge)
    story.append(Spacer(1, 10))

    story.append(Paragraph("Trailing Whitespace Trimming &amp; CRLF Normalization Algorithm", h2_style))
    story.append(Paragraph(
        "Online judge building mein sabse common bug hota hai <i>trailing newline issue</i>: User code output karta hai <code>'42\\n'</code> jabki expected output hota hai <code>'42'</code>. "
        "Agar naive string comparison karein to solution unfairly reject ho jata! "
        "Humne <code>ResultEvaluator.cpp</code> mein custom robust whitespace trimmer implement kiya hai:",
        body_style
    ))

    trim_code = (
        "string ResultEvaluator::trimRight(const string& s) {\n"
        "    size_t end = s.find_last_not_of(\" \\t\\r\\n\");\n"
        "    return (end == string::npos) ? \"\" : s.substr(0, end + 1);\n"
        "}\n\n"
        "// In evaluateTestCase:\n"
        "string cleanActual = trimRight(actualOutput);\n"
        "string cleanExpected = trimRight(expectedOutput);\n"
        "if (cleanActual == cleanExpected) {\n"
        "    return \"Accepted\";\n"
        "} else {\n"
        "    return \"Wrong Answer\";\n"
        "}"
    )
    story.append(make_code_box(trim_code))
    story.append(Spacer(1, 8))

    story.append(Paragraph(
        "<b>Bhai Dhyan Do:</b> Yeh function string ke end se space, tab, carriage return (<code>\\r</code>) aur newline (<code>\\n</code>) sabhi ko clean karta hai. "
        "Isse Windows vs Linux CRLF incompatibilities completely eliminate ho jati hain!",
        body_style
    ))

    # ==================================================================
    # PAGE 7: FULL-STACK FRONTEND SPA & DRAGGABLE RESIZERS
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("6. Full-Stack Single Page Application (`frontend/front_end.html`)", h1_style))
    story.append(Paragraph(
        "CodeBox ka frontend ek modern Single Page Application (SPA) hai jise bina kisi bloated heavy framework (React/Angular) ke "
        "pure high-performance <b>Vanilla ES6+ JavaScript</b>, <b>Tailwind CSS CDN</b>, aur <b>Microsoft Monaco Editor CDN</b> se banaya gaya hai. "
        "Phase 3 mein user interface ko production look dene ke liye 3 critical improvements kiye gaye hain:",
        body_style
    ))

    fe_features = (
        "<b>1. Mandatory Login Gate (Zero-Guest Security):</b><br/>"
        "Pehele Phase 2 mein guest access aur 1-click demo buttons the jisse fake test data aa jata tha. Phase 3 mein guest mode completely abolish kar diya gaya hai. "
        "Agar browser ke <code>localStorage</code> mein valid session nahi hai, to pura platform non-dismissible full-screen modal ke piche locked rehta hai. "
        "User ko register ya login karna hi padta hai. Isse Global Leaderboard 100% clean aur authentic rehta hai.<br/><br/>"
        "<b>2. Practice Questions UI (Optimized 42% / 58% Ratio):</b><br/>"
        "Pehle problem list, problem description, aur editor ek hi screen par 3 columns mein squeezed the. "
        "Phase 3 mein Problem Catalog ko ek smooth <b>Collapsible Drawer/Sidebar</b> bana diya gaya hai jo top bar button se toggle hota hai. "
        "Main viewport mein Problem Description ko 42% aur Code Editor ko 58% generous width di gayi hai.<br/><br/>"
        "<b>3. VS Code-Style Mouse-Draggable Split-Pane Resizers:</b><br/>"
        "Monaco editor aur consoles ke beech mouse drag dividers (<code>col-resize</code> and <code>row-resize</code>) lagaye gaye hain. "
        "User click karke pane width aur drawer height resize kar sakta hai. Resizing ke dauran transparent drag-shield activate hota hai taaki mouse cursor editor iframe ke andar trap na ho, aur <code>monacoEditor.layout()</code> dynamically call hota hai!"
    )
    story.append(make_callout(fe_features, bg=c_callout_bg, border=c_callout_border, title="Frontend Architecture Innovations"))
    story.append(Spacer(1, 10))

    story.append(Paragraph("Draggable Split-Pane Resizer Logic (Vanilla JS Implementation)", h2_style))
    resizer_js = (
        "function initSplitResizers() {\n"
        "    const divider = document.getElementById('pq-divider-v');\n"
        "    const leftPane = document.getElementById('pq-desc-pane');\n"
        "    const container = document.getElementById('pq-content-container');\n\n"
        "    let isDragging = false;\n"
        "    divider.addEventListener('mousedown', (e) => {\n"
        "        isDragging = true;\n"
        "        document.body.style.cursor = 'col-resize';\n"
        "        dragShield.style.display = 'block'; // Prevents Monaco mouse capture\n"
        "    });\n\n"
        "    window.addEventListener('mousemove', (e) => {\n"
        "        if (!isDragging) return;\n"
        "        const rect = container.getBoundingClientRect();\n"
        "        const newWidth = Math.max(250, Math.min(rect.width - 300, e.clientX - rect.left));\n"
        "        leftPane.style.width = newWidth + 'px';\n"
        "        if (window.practiceEditor) window.practiceEditor.layout(); // Smooth redraw!\n"
        "    });\n\n"
        "    window.addEventListener('mouseup', () => {\n"
        "        isDragging = false;\n"
        "        dragShield.style.display = 'none';\n"
        "        document.body.style.cursor = 'default';\n"
        "    });\n"
        "}"
    )
    story.append(make_code_box(resizer_js))
    story.append(Spacer(1, 8))

    story.append(Paragraph(
        "<b>Why Drag Shield is Important:</b> Monaco Editor internally ek complex DOM tree use karta hai jisme text spans aur inputs hote hain. "
        "Agar mouse drag karte waqt mouse pointer Monaco ke upar chala jaye, to Monaco <code>mousemove</code> events swallow kar leta hai, jisse drag freeze ho jata hai! "
        "Humne ek transparent <code>dragShield</code> overlay use kiya hai jo drag ke dauran pure screen ko cover kar leta hai, ensuring silky-smooth 60fps resizing!",
        body_style
    ))

    # ==================================================================
    # PAGE 8: REST API SPECIFICATION
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("7. REST API Endpoints Specification", h1_style))
    story.append(Paragraph(
        "CodeBox backend C++ <code>ApiHandler</code> class lightweight HTTP server (<code>httplib.h</code>) ke through "
        "production RESTful JSON APIs expose karti hai. Niche har endpoint ka complete specification diya gaya hai:",
        body_style
    ))

    api_table_data = [
        [Paragraph("<b>Method &amp; Path</b>", table_header_style), Paragraph("<b>Request Body</b>", table_header_style), Paragraph("<b>Response Payload</b>", table_header_style), Paragraph("<b>Functionality</b>", table_header_style)],
        [
            Paragraph("<b><code>GET /</code></b><br/><b><code>GET /front_end.html</code></b>", table_cell_bold),
            Paragraph("<i>None</i>", table_cell_style),
            Paragraph("HTML File (<code>frontend/front_end.html</code>)", table_cell_style),
            Paragraph("Serves the single-page frontend application from <code>frontend/</code> directory with fallback search.", table_cell_style)
        ],
        [
            Paragraph("<b><code>POST /api/register</code></b>", table_cell_bold),
            Paragraph("<code>{ username, email, password }</code>", table_cell_style),
            Paragraph("<code>{ status: 'ok', user_id: 1, username: 'dev' }</code>", table_cell_style),
            Paragraph("Creates new user in SQLite <code>users</code> table. Rejects duplicate username/email with HTTP 409.", table_cell_style)
        ],
        [
            Paragraph("<b><code>POST /api/login</code></b>", table_cell_bold),
            Paragraph("<code>{ identifier, password }</code>", table_cell_style),
            Paragraph("<code>{ status: 'ok', user: { user_id, username, email } }</code>", table_cell_style),
            Paragraph("Authenticates user credentials against database hash. Supports login via either username or email.", table_cell_style)
        ],
        [
            Paragraph("<b><code>GET /api/problems</code></b>", table_cell_bold),
            Paragraph("<i>Query:</i> <code>?user_id=1</code>", table_cell_style),
            Paragraph("<code>[ { problem_id, title, slug, difficulty, points, category, is_solved }, ... ]</code>", table_cell_style),
            Paragraph("Returns 30 DSA questions joined with 3NF lookup tables and calculated solved status for active user.", table_cell_style)
        ],
        [
            Paragraph("<b><code>GET /api/problems/:id</code></b>", table_cell_bold),
            Paragraph("<i>URL Parameter:</i> ID", table_cell_style),
            Paragraph("<code>{ problem_id, title, description, constraints, starter_c, starter_cpp, starter_python, starter_java, sample_testcases }</code>", table_cell_style),
            Paragraph("Fetches complete problem statement, constraints, 4-language starter templates, and sample test cases.", table_cell_style)
        ],
        [
            Paragraph("<b><code>POST /api/playground/run</code></b>", table_cell_bold),
            Paragraph("<code>{ language, code, stdin }</code>", table_cell_style),
            Paragraph("<code>{ status: 'success', stdout, stderr, execution_time_ms }</code>", table_cell_style),
            Paragraph("Ad-hoc code execution in Personal Coding Platform inside Docker with 256MB RAM and 2.0s timeout.", table_cell_style)
        ],
        [
            Paragraph("<b><code>POST /api/leetcode/submit</code></b>", table_cell_bold),
            Paragraph("<code>{ user_id, problem_id, language, code }</code>", table_cell_style),
            Paragraph("<code>{ status: 'Accepted' | 'Wrong Answer' | 'TLE' | 'CE', passed: 3, total: 3, execution_time_ms, memory_kb }</code>", table_cell_style),
            Paragraph("Executes code against all hidden test cases. Evaluates verdict, logs submission to DB, updates leaderboard.", table_cell_style)
        ],
        [
            Paragraph("<b><code>GET /api/leaderboard</code></b>", table_cell_bold),
            Paragraph("<i>None</i>", table_cell_style),
            Paragraph("<code>[ { rank: 1, username: 'alice', solved_count: 14, total_score: 280 }, ... ]</code>", table_cell_style),
            Paragraph("Returns ranked user leaderboard aggregated via 3NF SQL query sorted by points and solved counts.", table_cell_style)
        ],
        [
            Paragraph("<b><code>GET /api/user/stats</code></b>", table_cell_bold),
            Paragraph("<i>Query:</i> <code>?user_id=1</code>", table_cell_style),
            Paragraph("<code>{ total_solved: 5, easy_solved: 3, medium_solved: 2, hard_solved: 0, total_score: 70 }</code>", table_cell_style),
            Paragraph("Computes user problem solving metrics grouped by difficulty level for dashboard profile card.", table_cell_style)
        ],
    ]
    t_api = Table(api_table_data, colWidths=[105, 120, 145, 134])
    t_api.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_api)

    # ==================================================================
    # PAGE 9: CODE DEEP DIVE & IMPLEMENTATION POST-MORTEM
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("8. Backend Source Code Deep Dive &amp; Implementation Logic", h1_style))
    story.append(Paragraph(
        "Is section mein hum backend ke core C++ classes ke actual internal logic ka post-mortem karenge "
        "taaki viva mein agar examiner bole ki 'chalo screen pe code kholo aur yeh function explain karo', to tum confidently har ek line explain kar sako:",
        body_style
    ))

    story.append(Paragraph("1. `DatabaseManager.cpp` — Resilient Multi-Path DB &amp; Script Discovery", h2_style))
    story.append(Paragraph(
        "Kyunki project ko root folder se bhi chalaya ja sakta hai aur <code>backend/</code> folder se bhi, "
        "humne hardcoded paths ke bajaye <b>Candidate Path Discovery</b> implement kiya hai:",
        body_style
    ))
    db_snippet = (
        "bool DatabaseManager::init(const string& dbPath) {\n"
        "    lock_guard<mutex> lock(dbMtx);\n"
        "    if (db) return true;\n\n"
        "    // Build candidate paths: 'database/codebox.db', '../database/codebox.db', 'codebox.db'\n"
        "    vector<string> candidates = { dbPath, \"../\" + dbPath };\n"
        "    if (dbPath.rfind(\"database/\", 0) == 0) candidates.push_back(dbPath.substr(9));\n\n"
        "    sqlite3* tempDb = nullptr;\n"
        "    for (const auto& c : candidates) {\n"
        "        if (sqlite3_open(c.c_str(), &tempDb) == SQLITE_OK && tempDb != nullptr) {\n"
        "            db = tempDb;\n"
        "            dbFilePath = c;\n"
        "            break;\n"
        "        }\n"
        "        if (tempDb) { sqlite3_close(tempDb); tempDb = nullptr; }\n"
        "    }\n"
        "    if (!db) return false;\n\n"
        "    // WAL mode & Foreign keys\n"
        "    sqlite3_exec(db, \"PRAGMA foreign_keys = ON;\", nullptr, nullptr, nullptr);\n"
        "    sqlite3_exec(db, \"PRAGMA journal_mode = WAL;\", nullptr, nullptr, nullptr);\n"
        "    return true;\n"
        "}"
    )
    story.append(make_code_box(db_snippet))
    story.append(Spacer(1, 8))

    story.append(Paragraph("2. `ApiHandler.cpp` — Multi-Test-Case Judge Loop with Short-Circuit Failure", h2_style))
    api_snippet = (
        "// In ApiHandler::handleLeetCodeSubmit:\n"
        "auto testCases = db.getProblemTestCases(problemId);\n"
        "int passedCount = 0;\n"
        "string overallVerdict = \"Accepted\";\n\n"
        "for (const auto& tc : testCases) {\n"
        "    // Submit execution to thread pool\n"
        "    ExecutionTask task(lang, code, tc.inputData);\n"
        "    auto future = scheduler.submit(task);\n"
        "    ExecutionResult res = future.get(); // Wait for Docker\n\n"
        "    string verdict = ResultEvaluator::evaluate(res, tc.expectedOutput);\n"
        "    if (verdict != \"Accepted\") {\n"
        "        overallVerdict = verdict; // e.g. 'Wrong Answer' or 'Time Limit Exceeded'\n"
        "        break; // Stop immediately on first failing test case!\n"
        "    }\n"
        "    passedCount++;\n"
        "}\n"
        "// Log submission audit into SQLite3\n"
        "db.recordSubmission(userId, problemId, lang, overallVerdict, passedCount, testCases.size());"
    )
    story.append(make_code_box(api_snippet))
    story.append(Spacer(1, 6))

    story.append(Paragraph(
        "<b>Architectural Efficiency:</b> Jab user ka code 10 test cases mein se test case 2 par fail hota hai, "
        "to engine baaki 8 test cases run karke compute waste nahi karta! Loop immediate break ho jata hai aur user ko fastest feedback milta hai.",
        body_style
    ))

    # ==================================================================
    # PAGE 10: HOW TO RUN & BUILD GUIDE
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("9. Step-by-Step Build, Run &amp; Verification Manual", h1_style))
    story.append(Paragraph(
        "External evaluator ya professor ke samne project ko run karke dikhane ke liye exact command sequences aur expected outputs:",
        body_style
    ))

    steps_text = (
        "<b>Step 1: Prerequisites Check (WSL2 / Linux Terminal)</b><br/>"
        "Make sure GCC C++17, Docker, Make, and SQLite3 libraries are installed:<br/>"
        "<code>sudo apt update &amp;&amp; sudo apt install -y g++ make libsqlite3-dev docker.io</code><br/><br/>"
        "<b>Step 2: Clean Build Using Root Makefile</b><br/>"
        "Root directory mein jakar release binary build karein:<br/>"
        "<code>make clean &amp;&amp; make release</code><br/>"
        "<i>Output:</i> Compiles <code>backend/*.cpp</code> files with <code>-Ibackend -lsqlite3 -O2</code> into <code>codebox_server</code>.<br/><br/>"
        "<b>Step 3: Launch CodeBox Engine</b><br/>"
        "Server start karein:<br/>"
        "<code>./codebox_server</code><br/>"
        "<i>Terminal Logs Confirming 3NF &amp; Worker Initialization:</i><br/>"
        "• <code>[Init] Checking SQLite database &amp; 3NF schema...</code><br/>"
        "• <code>DatabaseManager: SQLite database initialized at database/codebox.db</code><br/>"
        "• <code>DatabaseManager: 3NF database schema and problems already exist.</code><br/>"
        "• <code>[Init] Starting QueueScheduler worker pool (3 FCFS threads)...</code><br/>"
        "• <code>QueueScheduler: started 3 worker threads</code><br/>"
        "• <code>[Ready] Server listening on http://0.0.0.0:8080</code><br/><br/>"
        "<b>Step 4: Open in Web Browser</b><br/>"
        "Open <code>http://localhost:8080</code> in Chrome/Edge/Firefox. The mandatory login modal appears.<br/>"
        "Create an account or login to access <b>Practice Questions</b>, solve problems, submit code, and climb the Global Leaderboard!"
    )
    story.append(make_callout(steps_text, bg=c_note_bg, border=c_note_border, title="Terminal Execution Commands"))
    story.append(Spacer(1, 10))

    story.append(Paragraph("Verifying REST Endpoints via cURL", h2_style))
    curl_sample = (
        "# 1. Test Web Server (Returns front_end.html from frontend/)\n"
        "curl -I http://localhost:8080/\n"
        "# Expected: HTTP/1.1 200 OK | Content-Type: text/html\n\n"
        "# 2. Test 3NF Problem Catalog API\n"
        "curl -s http://localhost:8080/api/problems | jq '.[0]'\n"
        "# Expected: { \"problem_id\": 1, \"title\": \"Two Sum\", \"difficulty\": \"Easy\", \"points\": 10 }\n\n"
        "# 3. Test Leaderboard API\n"
        "curl -s http://localhost:8080/api/leaderboard\n"
        "# Expected: [ { \"rank\": 1, \"username\": \"...\", \"solved_count\": ..., \"total_score\": ... } ]"
    )
    story.append(make_code_box(curl_sample))

    # ==================================================================
    # PAGE 11-12: COMPREHENSIVE VIVA VOCE DEFENSE MANUAL (25 Q&As)
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("10. Exhaustive Viva Voce Defense Guide (B.Tech CSE Evaluator Q&amp;A)", h1_style))
    story.append(Paragraph(
        "Yeh section tumhare aur tumhare dosto ke liye goldmine hai. "
        "Yahan par B.Tech CSE external evaluators ke 20+ sabse common aur dangerous technical questions unke exact rock-solid Hinglish answers ke sath diye gaye hain:",
        body_style
    ))

    vivas = [
        (
            "Q1: Tumne Phase 3 mein SQLite database ko 3NF (Third Normal Form) mein kyu design kiya? Iska kya faida hai?",
            "Ans: 'Sir, 3NF ka main objective hota hai transitive dependency ko eliminate karna. Agar hum problems table ke andar hi difficulty_name aur points store karte, to problem_id -> difficulty_name -> points ban jata. Kal agar hum 'Easy' category ke points 10 se badha kar 15 karte, to hume hazaron rows update karni padti jo Update Anomaly create karta. 3NF mein humne difficulties, categories aur languages ko separate lookup tables mein rakha hai aur problems table mein sirf Foreign Keys refer ki hain. Isse zero data redundancy, high referential integrity, aur clean normalization achieve hui hai.'"
        ),
        (
            "Q2: SQLite to single-file embedded database hai. Production mein concurrency aur locking ka issue kaise handle kiya?",
            "Ans: 'Sir, SQLite default rollback journal mode mein poore database file ko lock kar deta hai. Isko solve karne ke liye humne do major cheezen ki hain: (1) PRAGMA journal_mode = WAL (Write-Ahead Logging) enable kiya hai jisse Concurrent Readers aur Writers ek sath execute hote hain without blocking each other. (2) PRAGMA busy_timeout = 5000 set kiya hai jisse agar koi write lock active bhi ho, to incoming queries fail nahi hoti balki 5 seconds tak gracefully wait karti hain. Iske sath C++ DatabaseManager class mein std::mutex use karke SQLite connection ko thread-safe banaya hai.'"
        ),
        (
            "Q3: Multi-test-case judge evaluation mein trailing whitespace aur CRLF issue kaise solve kiya?",
            "Ans: 'Sir, online judge mein sabse common problem hoti hai ki user output ke end mein extra space, tab ya newline '\\n' print kar deta hai ya fir Windows CRLF ('\\r\\n') vs Linux LF ('\\n') mismatch ho jata hai. Humne ResultEvaluator class ke andar custom trimRight() function implement kiya hai jo string ke right side se spaces, tabs, '\\r' aur '\\n' ko sanitize karta hai before comparison. Isse output matching 100% fair aur accurate ho jati hai.'"
        ),
        (
            "Q4: Tumhara C++ execution engine multi-threaded hai. Worker threads manage karne ke liye konsi data structures use ki hain?",
            "Ans: 'Sir, QueueScheduler class mein humne ek custom Thread Pool implement kiya hai jisme 3 persistent worker threads run hote hain. Tasks ko store karne ke liye std::queue<ExecutionTask> use kiya gaya hai. Thread synchronization ke liye std::mutex aur std::condition_variable ka use kiya hai. Jab queue empty hoti hai to worker threads condition variable par sleep mode mein wait karte hain (zero CPU burn). Jaise hi naya task push hota hai, cv.notify_one() ek worker thread ko wake up karti hai FCFS order mein.'"
        ),
        (
            "Q5: Security ke perspective se user code ko host machine par run hone se kaise roka?",
            "Ans: 'Sir, hum user code ko host OS par direct run nahi karte. DockerSandbox class har execution ke liye ek isolated ephemeral Docker container launch karti hai with strict cgroups restrictions: (1) Memory limit locked at --memory=256m, (2) Network completely disabled via --network none taaki malicious code koi external server ping na kar sake, (3) Watchdog timer timeout -s KILL 2.0s jo infinite loops ko 2 seconds mein forcefully kill kar deta hai, aur (4) Ephemeral flag --rm jo execution ke baad container aur temporary files ko instantly delete kar deta hai.'"
        ),
        (
            "Q6: Java code execution mein filename aur class name matching ka kya challenge tha?",
            "Ans: 'Sir, Java compiler javac strict rule enforce karta hai ki public class ka name aur .java filename exact same hone chahiye. Agar user class Solution likhta hai to file Solution.java honi chahiye. FileManager class user code ko regex se scan karti hai: agar user class Solution declare karta hai to filename Solution.java set hota hai, varna class name extract karke uske corresponding .java file write ki jati hai.'"
        ),
        (
            "Q7: C language (GCC) support add karne ke liye pure stack mein kya kya changes karne pade?",
            "Ans: 'Sir, C support add karne ke liye humne full-stack modification kiya: (1) Backend LanguageConfig mein 'c' register kiya with file main.c, compiler gcc -O2 main.c -o main, aur execution command ./main. (2) Database schema mein problems table par starter_c column add kiya aur seed script mein 30 DSA questions ke working C starters insert kiye. (3) Frontend Monaco Editor mein C (GCC) syntax highlighting aur starter template wire kiya.'"
        ),
        (
            "Q8: Frontend mein draggable split-pane resizers implement karte waqt Monaco Editor mein kya glitch aa raha tha aur kaise fix kiya?",
            "Ans: 'Sir, jab mouse drag karke pane width resize karte the, to jaise hi cursor Monaco Editor ke upar jata tha, Monaco ka internal DOM tree mouse events ko capture/swallow kar leta tha, jisse drag release ho jata tha ya freeze ho jata tha. Isko solve karne ke liye humne ek transparent dragShield overlay create kiya jo mousedown par pure viewport ko cover kar leta hai. Mouseup par shield hide ho jati hai aur continuously monacoEditor.layout() trigger hota hai, providing a smooth 60fps VS Code like resize experience.'"
        ),
        (
            "Q9: Guest Mode kyu remove kiya aur Mandatory Login Gate kyu lagaya?",
            "Ans: 'Sir, Guest mode allow karne se anonymous users arbitrary code submit kar dete the jisse Global Leaderboard pollute ho jata tha aur accurate user solved metrics track nahi ho paate the. Mandatory Login Gate lagane se zero-trust security enforce hui hai: har submission authenticated user_id ke sath foreign-key linked hoti hai, ensuring transparent rankings aur authentic user progress tracking.'"
        ),
        (
            "Q10: Leaderboard query mein COUNT(DISTINCT s.problem_id) kyu use kiya? Plain COUNT(*) kyu nahi?",
            "Ans: 'Sir, agar koi user ek hi problem (e.g. Two Sum) ko 10 baar submit karke Accepted verdict lata hai, to plain COUNT(*) uska solved count 10 dikha dega jo unfair hoga. COUNT(DISTINCT s.problem_id) ensure karta hai ki ek problem solve karne par user ka count aur points sirf ek hi baar add hon, regardless of multiple submissions!'"
        ),
    ]

    for q, a in vivas:
        p_q = Paragraph(f"<b>{q}</b>", viva_q_style)
        p_a = Paragraph(a, viva_ans_style)
        t_box = Table([[p_q], [p_a]], colWidths=[504])
        t_box.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F8FAFC")),
            ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
            ('LINELEFT', (0,0), (0,-1), 3, c_primary),
            ('LEFTPADDING', (0,0), (-1,-1), 8),
            ('RIGHTPADDING', (0,0), (-1,-1), 8),
            ('TOPPADDING', (0,0), (-1,-1), 4),
            ('BOTTOMPADDING', (0,0), (-1,-1), 4),
        ]))
        story.append(t_box)
        story.append(Spacer(1, 4))

    # ==================================================================
    # PAGE 13: CONCLUSION & DEFENSE CHECKLIST
    # ==================================================================
    story.append(PageBreak())
    story.append(Paragraph("11. Final Defense Checklist &amp; Project Summary", h1_style))
    story.append(Paragraph(
        "Examiner ke aane se 5 minute pehle yeh quick checklist verify kar lo:",
        body_style
    ))

    checklist_data = [
        [Paragraph("<b>Component</b>", table_header_style), Paragraph("<b>Verification Status</b>", table_header_style), Paragraph("<b>Verification Command / Proof</b>", table_header_style)],
        [
            Paragraph("<b>Relational 3NF Database</b>", table_cell_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED (3NF)</b></font>", table_cell_style),
            Paragraph("<code>sqlite3 database/codebox.db \".tables\"</code> -> 7 tables verified with foreign keys enabled.", table_cell_style)
        ],
        [
            Paragraph("<b>30+ DSA Problems Seeded</b>", table_cell_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED (100%)</b></font>", table_cell_style),
            Paragraph("<code>SELECT count(*) FROM problems;</code> -> 30 problems with C, C++, Python, Java starters.", table_cell_style)
        ],
        [
            Paragraph("<b>Containerized Sandbox</b>", table_cell_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED (Secure)</b></font>", table_cell_style),
            Paragraph("Docker daemon running with <code>gcc:latest</code>, <code>python:3</code>, <code>openjdk:17</code> images pulled.", table_cell_style)
        ],
        [
            Paragraph("<b>QueueScheduler Thread Pool</b>", table_cell_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED (3 Workers)</b></font>", table_cell_style),
            Paragraph("FCFS queue with <code>std::mutex</code>, <code>condition_variable</code>, zero busy waiting.", table_cell_style)
        ],
        [
            Paragraph("<b>Modular Folder Hierarchy</b>", table_cell_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED (Clean)</b></font>", table_cell_style),
            Paragraph("Clean <code>frontend/</code>, <code>database/</code>, and <code>backend/</code> directories with root Makefile.", table_cell_style)
        ],
        [
            Paragraph("<b>Draggable Monaco UI</b>", table_cell_bold),
            Paragraph("<font color='#16A34A'><b>VERIFIED (Smooth)</b></font>", table_cell_style),
            Paragraph("Mouse draggable resizers, collapsible problem catalog, mandatory login screen.", table_cell_style)
        ],
    ]
    t_check = Table(checklist_data, colWidths=[120, 110, 274])
    t_check.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_primary),
        ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
        ('TOPPADDING', (0,0), (-1,-1), 5),
        ('BOTTOMPADDING', (0,0), (-1,-1), 5),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor("#F8FAFC")]),
    ]))
    story.append(t_check)
    story.append(Spacer(1, 14))

    closing_callout = (
        "<b>Final Words for Team ayush908828:</b><br/>"
        "Bhai, tumhara CodeBox project ab kisi bhi regular college project se 10x aage hai. "
        "Isme real OS primitives (Docker cgroups, SIGKILL watchdog, POSIX signals), real concurrency (C++17 Thread Pool, Condition Variables), "
        "real Database Engineering (Strict 3NF, WAL mode, foreign keys), aur real modern Web Engineering (Monaco Editor, draggable split panes, REST APIs) implement hui hai. "
        "Confidence ke sath viva do, you guys have built something truly production-grade!"
    )
    story.append(make_callout(closing_callout, bg=c_callout_bg, border=c_callout_border, title="All The Best For Project Defense!"))

    # Build the PDF
    doc.build(story, canvasmaker=NumberedCanvas)
    print(f"[Success] PDF generated successfully at: {output_path}")

if __name__ == "__main__":
    out_pdf = os.path.join(os.getcwd(), "DETAILS", "CodeBox_Phase3.pdf")
    build_phase3_pdf(out_pdf)
