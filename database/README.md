# CodeBox - Database Module (Work In Progress)

**Current Status:** Phase 2 Draft (1NF Level)  
**Planned Target:** 3NF Normalization & PostgreSQL Integration in Phase 3

---

### 1. What We Have Done So Far
- Designed initial draft schema (`schema.sql`) in **1NF (First Normal Form)** with atomic columns.
- Created basic core tables:
  1. `users` (user credentials and basic profile)
  2. `problems` (problem title, description, and sample test case)
  3. `submissions` (raw submission log storing language, code, status, and execution time)
- Wrote basic CRUD queries (`queries.sql`) for manual verification.

---

### 2. Next Steps / Pending Work (Sprint 3)
- [ ] **Normalization (2NF & 3NF):** Separate test cases from `problems` into an independent `test_cases` table to avoid repeating test data.
- [ ] **Foreign Keys & Integrity:** Add `REFERENCES` constraints and `ON DELETE CASCADE` between users, problems, and submissions.
- [ ] **Indexing:** Create B-Tree indexes on `user_id` and `problem_id` for faster lookups.
- [ ] **Backend Connection:** Connect C++ server to PostgreSQL using `libpqxx` driver.
