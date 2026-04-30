-- Consolidated migration: safe to run on a completely fresh Supabase project.
-- Uses IF NOT EXISTS / CREATE OR REPLACE / DROP IF EXISTS throughout.

-- ─── Migration 0: meetings + meeting_attendees ────────────────────────────────

CREATE TABLE IF NOT EXISTS meetings (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  title       text        NOT NULL,
  description text,
  location    text,
  start_time  timestamptz NOT NULL,
  end_time    timestamptz NOT NULL,
  created_by  uuid        REFERENCES auth.users(id),
  created_at  timestamptz DEFAULT now(),
  updated_at  timestamptz DEFAULT now(),
  ics_uid     text        DEFAULT gen_random_uuid()::text
);

CREATE TABLE IF NOT EXISTS meeting_attendees (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  meeting_id uuid REFERENCES meetings(id) ON DELETE CASCADE,
  name       text NOT NULL,
  email      text NOT NULL,
  role       text NOT NULL CHECK (role IN ('organizer', 'co_organizer', 'attendee')),
  added_at   timestamptz DEFAULT now()
);

ALTER TABLE meetings          ENABLE ROW LEVEL SECURITY;
ALTER TABLE meeting_attendees ENABLE ROW LEVEL SECURITY;

-- ─── Migration 1: cohorts ─────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS cohorts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  members jsonb NOT NULL DEFAULT '[]',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE cohorts ENABLE ROW LEVEL SECURITY;

-- ─── Migration 2: physical_location on meetings ───────────────────────────────

ALTER TABLE meetings ADD COLUMN IF NOT EXISTS physical_location text;

-- ─── Migration 3: expand organizer allowlist to include mbaa@uw.edu ──────────

DROP POLICY IF EXISTS "portal_organizers_only" ON meetings;
DROP POLICY IF EXISTS "portal_organizers_only" ON meeting_attendees;
DROP POLICY IF EXISTS "portal_organizers_only" ON cohorts;

CREATE POLICY "portal_organizers_only" ON meetings
  FOR ALL
  USING  (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'))
  WITH CHECK (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'));

CREATE POLICY "portal_organizers_only" ON meeting_attendees
  FOR ALL
  USING  (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'))
  WITH CHECK (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'));

CREATE POLICY "portal_organizers_only" ON cohorts
  FOR ALL
  USING  (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'))
  WITH CHECK (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'));

-- ─── Migration 4: student portal tables + storage ─────────────────────────────

CREATE TABLE IF NOT EXISTS companies (
  id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  name       text        NOT NULL,
  slug       text        UNIQUE NOT NULL,
  logo_url   text,
  sector     text,
  active     boolean     DEFAULT true,
  created_at timestamptz DEFAULT now()
);

CREATE TABLE IF NOT EXISTS student_profiles (
  id            uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id    uuid        REFERENCES companies(id) ON DELETE CASCADE,
  student_name  text        DEFAULT '',
  student_email text        DEFAULT '',
  photo_url     text,
  resume_url    text,
  updated_at    timestamptz DEFAULT now(),
  UNIQUE (company_id)
);

CREATE TABLE IF NOT EXISTS deliverables (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id  uuid        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  week_number integer     NOT NULL CHECK (week_number BETWEEN 1 AND 6),
  subheading  text        DEFAULT '',
  notes       text        DEFAULT '',
  updated_at  timestamptz DEFAULT now(),
  UNIQUE (company_id, week_number)
);

CREATE TABLE IF NOT EXISTS deliverable_files (
  id             uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  deliverable_id uuid        NOT NULL REFERENCES deliverables(id) ON DELETE CASCADE,
  file_name      text        NOT NULL,
  file_url       text        NOT NULL,
  file_type      text,
  file_size      bigint,
  created_at     timestamptz DEFAULT now()
);

ALTER TABLE companies        ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE deliverables     ENABLE ROW LEVEL SECURITY;
ALTER TABLE deliverable_files ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_companies"   ON companies;
DROP POLICY IF EXISTS "organizer_write_companies" ON companies;
DROP POLICY IF EXISTS "public_read_profiles"    ON student_profiles;
DROP POLICY IF EXISTS "anon_insert_profiles"    ON student_profiles;
DROP POLICY IF EXISTS "anon_update_profiles"    ON student_profiles;
DROP POLICY IF EXISTS "public_read_deliverables"  ON deliverables;
DROP POLICY IF EXISTS "anon_insert_deliverables"  ON deliverables;
DROP POLICY IF EXISTS "anon_update_deliverables"  ON deliverables;
DROP POLICY IF EXISTS "public_read_files"       ON deliverable_files;
DROP POLICY IF EXISTS "anon_insert_files"       ON deliverable_files;
DROP POLICY IF EXISTS "anon_delete_files"       ON deliverable_files;

CREATE POLICY "public_read_companies" ON companies
  FOR SELECT TO anon USING (active = true);

CREATE POLICY "organizer_write_companies" ON companies
  FOR ALL
  USING  (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'))
  WITH CHECK (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'));

CREATE POLICY "public_read_profiles"   ON student_profiles FOR SELECT TO anon USING (true);
CREATE POLICY "anon_insert_profiles"   ON student_profiles FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_update_profiles"   ON student_profiles FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE POLICY "public_read_deliverables"  ON deliverables FOR SELECT TO anon USING (true);
CREATE POLICY "anon_insert_deliverables"  ON deliverables FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_update_deliverables"  ON deliverables FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE POLICY "public_read_files"  ON deliverable_files FOR SELECT TO anon USING (true);
CREATE POLICY "anon_insert_files"  ON deliverable_files FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_delete_files"  ON deliverable_files FOR DELETE TO anon USING (true);

-- Storage bucket (skip if already exists)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'student-portal', 'student-portal', true, 52428800,
  ARRAY[
    'image/jpeg','image/png','image/gif','image/webp',
    'application/pdf',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/msword',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation'
  ]
) ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "public_read_storage"  ON storage.objects;
DROP POLICY IF EXISTS "anon_upload_storage"  ON storage.objects;
DROP POLICY IF EXISTS "anon_delete_storage"  ON storage.objects;

CREATE POLICY "public_read_storage" ON storage.objects
  FOR SELECT TO anon USING (bucket_id = 'student-portal');
CREATE POLICY "anon_upload_storage" ON storage.objects
  FOR INSERT TO anon WITH CHECK (bucket_id = 'student-portal');
CREATE POLICY "anon_delete_storage" ON storage.objects
  FOR DELETE TO anon USING (bucket_id = 'student-portal');

-- ─── Migration 5: student & company portal auth ───────────────────────────────

-- Tables first so the functions that reference them can be created after

CREATE TABLE IF NOT EXISTS student_assignments (
  id            uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  student_email text        NOT NULL,
  student_name  text        DEFAULT '',
  company_id    uuid        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  created_at    timestamptz DEFAULT now(),
  UNIQUE (student_email)
);

CREATE TABLE IF NOT EXISTS company_contacts (
  id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id uuid        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  email      text        NOT NULL,
  name       text        DEFAULT '',
  created_at timestamptz DEFAULT now(),
  UNIQUE (email)
);

-- Functions defined after their referenced tables exist

CREATE OR REPLACE FUNCTION is_cohort_member(p_email text)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM cohorts, jsonb_array_elements(members) AS m
    WHERE lower(m->>'email') = lower(p_email)
  );
$$;

CREATE OR REPLACE FUNCTION is_company_contact(p_email text)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM company_contacts WHERE lower(email) = lower(p_email)
  );
$$;

CREATE TABLE IF NOT EXISTS deliverable_comments (
  id             uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  deliverable_id uuid        NOT NULL REFERENCES deliverables(id) ON DELETE CASCADE,
  author_email   text        NOT NULL,
  author_name    text        DEFAULT '',
  author_type    text        NOT NULL CHECK (author_type IN ('student', 'company')),
  body           text        NOT NULL CHECK (trim(body) <> ''),
  created_at     timestamptz DEFAULT now()
);

ALTER TABLE deliverable_files ADD COLUMN IF NOT EXISTS student_comment text DEFAULT '';

ALTER TABLE student_assignments   ENABLE ROW LEVEL SECURITY;
ALTER TABLE company_contacts      ENABLE ROW LEVEL SECURITY;
ALTER TABLE deliverable_comments  ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "student_read_own_assignment"    ON student_assignments;
DROP POLICY IF EXISTS "organizer_manage_assignments"   ON student_assignments;
DROP POLICY IF EXISTS "contact_read_own"               ON company_contacts;
DROP POLICY IF EXISTS "organizer_manage_contacts"      ON company_contacts;
DROP POLICY IF EXISTS "auth_read_comments"             ON deliverable_comments;
DROP POLICY IF EXISTS "auth_insert_comments"           ON deliverable_comments;
DROP POLICY IF EXISTS "auth_read_deliverables"         ON deliverables;
DROP POLICY IF EXISTS "auth_write_deliverables"        ON deliverables;
DROP POLICY IF EXISTS "auth_update_deliverables"       ON deliverables;
DROP POLICY IF EXISTS "auth_read_files"                ON deliverable_files;
DROP POLICY IF EXISTS "auth_insert_files"              ON deliverable_files;
DROP POLICY IF EXISTS "auth_update_files"              ON deliverable_files;
DROP POLICY IF EXISTS "auth_delete_files"              ON deliverable_files;
DROP POLICY IF EXISTS "auth_read_companies"            ON companies;
DROP POLICY IF EXISTS "organizer_write_companies_auth" ON companies;

CREATE POLICY "student_read_own_assignment" ON student_assignments
  FOR SELECT TO authenticated
  USING (lower(student_email) = lower(auth.jwt() ->> 'email'));

CREATE POLICY "organizer_manage_assignments" ON student_assignments
  FOR ALL
  USING  (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'))
  WITH CHECK (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'));

CREATE POLICY "contact_read_own" ON company_contacts
  FOR SELECT TO authenticated
  USING (lower(email) = lower(auth.jwt() ->> 'email'));

CREATE POLICY "organizer_manage_contacts" ON company_contacts
  FOR ALL
  USING  (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'))
  WITH CHECK (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'));

CREATE POLICY "auth_read_comments" ON deliverable_comments
  FOR SELECT TO authenticated USING (true);

CREATE POLICY "auth_insert_comments" ON deliverable_comments
  FOR INSERT TO authenticated
  WITH CHECK (lower(author_email) = lower(auth.jwt() ->> 'email'));

CREATE POLICY "auth_read_deliverables"   ON deliverables      FOR SELECT TO authenticated USING (true);
CREATE POLICY "auth_write_deliverables"  ON deliverables      FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "auth_update_deliverables" ON deliverables      FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_read_files"          ON deliverable_files FOR SELECT TO authenticated USING (true);
CREATE POLICY "auth_insert_files"        ON deliverable_files FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "auth_update_files"        ON deliverable_files FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "auth_delete_files"        ON deliverable_files FOR DELETE TO authenticated USING (true);
CREATE POLICY "auth_read_companies"      ON companies         FOR SELECT TO authenticated USING (active = true);

CREATE POLICY "organizer_write_companies_auth" ON companies
  FOR ALL TO authenticated
  USING  (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'))
  WITH CHECK (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu','mbaa@uw.edu'));
