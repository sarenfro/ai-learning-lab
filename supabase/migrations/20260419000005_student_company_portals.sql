-- Student & Company portal auth tables, comments, and helpers

-- ─── Tables first (functions below reference these) ──────────────────────────

-- ─── Student assignments ─────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS student_assignments (
  id            uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  student_email text        NOT NULL,
  student_name  text        DEFAULT '',
  company_id    uuid        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  created_at    timestamptz DEFAULT now(),
  UNIQUE (student_email)
);

-- ─── Company contacts (portal logins for sponsors / founders) ─────────────────

CREATE TABLE IF NOT EXISTS company_contacts (
  id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  email      text        NOT NULL,
  name       text        DEFAULT '',
  created_at timestamptz DEFAULT now(),
  UNIQUE (email)
);

-- ─── Helper functions (SECURITY DEFINER bypasses RLS for auth checks) ────────

-- Used by student portal login to verify cohort membership before sending OTP
CREATE OR REPLACE FUNCTION is_cohort_member(p_email text)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM cohorts,
    jsonb_array_elements(members) AS m
    WHERE lower(m->>'email') = lower(p_email)
  );
$$;

-- Used by company portal login to verify access before sending OTP
CREATE OR REPLACE FUNCTION is_company_contact(p_email text)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM company_contacts
    WHERE lower(email) = lower(p_email)
  );
$$;

-- ─── Comments on deliverables (company-authored; students read them) ──────────

CREATE TABLE IF NOT EXISTS deliverable_comments (
  id             uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  deliverable_id uuid        NOT NULL REFERENCES deliverables(id) ON DELETE CASCADE,
  author_email   text        NOT NULL,
  author_name    text        DEFAULT '',
  author_type    text        NOT NULL CHECK (author_type IN ('student', 'company')),
  body           text        NOT NULL CHECK (trim(body) <> ''),
  created_at     timestamptz DEFAULT now()
);

-- ─── Per-file student comment (caption / context for each uploaded file) ──────

ALTER TABLE deliverable_files ADD COLUMN IF NOT EXISTS student_comment text DEFAULT '';

-- ─── Row-Level Security ───────────────────────────────────────────────────────

ALTER TABLE student_assignments   ENABLE ROW LEVEL SECURITY;
ALTER TABLE company_contacts      ENABLE ROW LEVEL SECURITY;
ALTER TABLE deliverable_comments  ENABLE ROW LEVEL SECURITY;

-- student_assignments: each student reads their own row; organizers manage all
CREATE POLICY "student_read_own_assignment" ON student_assignments
  FOR SELECT TO authenticated
  USING (lower(student_email) = lower(auth.jwt() ->> 'email'));

CREATE POLICY "organizer_manage_assignments" ON student_assignments
  FOR ALL
  USING  (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'))
  WITH CHECK (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'));

-- company_contacts: each contact reads their own; organizers manage all
CREATE POLICY "contact_read_own" ON company_contacts
  FOR SELECT TO authenticated
  USING (lower(email) = lower(auth.jwt() ->> 'email'));

CREATE POLICY "organizer_manage_contacts" ON company_contacts
  FOR ALL
  USING  (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'))
  WITH CHECK (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'));

-- deliverable_comments: any authenticated user can read; inserts verified by email
CREATE POLICY "auth_read_comments" ON deliverable_comments
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "auth_insert_comments" ON deliverable_comments
  FOR INSERT TO authenticated
  WITH CHECK (lower(author_email) = lower(auth.jwt() ->> 'email'));

-- authenticated read/write for deliverables + files (students are authenticated)
CREATE POLICY "auth_read_deliverables"   ON deliverables      FOR SELECT TO authenticated USING (true);
CREATE POLICY "auth_write_deliverables"  ON deliverables      FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "auth_update_deliverables" ON deliverables      FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_read_files"          ON deliverable_files FOR SELECT TO authenticated USING (true);
CREATE POLICY "auth_insert_files"        ON deliverable_files FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "auth_update_files"        ON deliverable_files FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_delete_files"        ON deliverable_files FOR DELETE TO authenticated USING (true);
CREATE POLICY "auth_read_companies"      ON companies         FOR SELECT TO authenticated USING (active = true);

-- organizers can manage companies while authenticated
CREATE POLICY "organizer_write_companies_auth" ON companies
  FOR ALL TO authenticated
  USING  (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'))
  WITH CHECK (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'));
