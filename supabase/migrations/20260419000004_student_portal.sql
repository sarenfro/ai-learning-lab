-- Student Portal: companies, student profiles, deliverables, files, storage bucket

-- ─── Tables ──────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS companies (
  id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  name       text        NOT NULL,
  slug       text        UNIQUE NOT NULL,
  logo_url   text,
  sector     text,
  active     boolean     DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- One student profile per company (the assigned analyst team)
CREATE TABLE IF NOT EXISTS student_profiles (
  id            uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id    uuid        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  student_name  text        DEFAULT '',
  student_email text        DEFAULT '',
  photo_url     text,
  resume_url    text,
  updated_at    timestamptz DEFAULT now(),
  UNIQUE (company_id)
);

-- Weekly deliverables, one row per company per week (weeks 1–6)
CREATE TABLE IF NOT EXISTS deliverables (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id  uuid        NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  week_number integer     NOT NULL CHECK (week_number BETWEEN 1 AND 6),
  subheading  text        DEFAULT '',
  notes       text        DEFAULT '',
  updated_at  timestamptz DEFAULT now(),
  UNIQUE (company_id, week_number)
);

-- Files attached to a deliverable
CREATE TABLE IF NOT EXISTS deliverable_files (
  id             uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  deliverable_id uuid        NOT NULL REFERENCES deliverables(id) ON DELETE CASCADE,
  file_name      text        NOT NULL,
  file_url       text        NOT NULL,
  file_type      text,
  file_size      bigint,
  created_at     timestamptz DEFAULT now()
);

-- ─── Row-Level Security ───────────────────────────────────────────────────────

ALTER TABLE companies         ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_profiles  ENABLE ROW LEVEL SECURITY;
ALTER TABLE deliverables      ENABLE ROW LEVEL SECURITY;
ALTER TABLE deliverable_files ENABLE ROW LEVEL SECURITY;

-- Companies: public read; organizer write only
CREATE POLICY "public_read_companies" ON companies
  FOR SELECT TO anon USING (active = true);

CREATE POLICY "organizer_write_companies" ON companies
  FOR ALL
  USING  (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu'))
  WITH CHECK (auth.jwt() ->> 'email' IN ('russ@speycast.com','colettev@uw.edu','sarenfro@uw.edu'));

-- Student content: public read + anon write (no auth required for student portal)
CREATE POLICY "public_read_profiles"   ON student_profiles FOR SELECT TO anon USING (true);
CREATE POLICY "anon_insert_profiles"   ON student_profiles FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_update_profiles"   ON student_profiles FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE POLICY "public_read_deliverables"  ON deliverables FOR SELECT TO anon USING (true);
CREATE POLICY "anon_insert_deliverables"  ON deliverables FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_update_deliverables"  ON deliverables FOR UPDATE TO anon USING (true) WITH CHECK (true);

CREATE POLICY "public_read_files"  ON deliverable_files FOR SELECT TO anon USING (true);
CREATE POLICY "anon_insert_files"  ON deliverable_files FOR INSERT TO anon WITH CHECK (true);
CREATE POLICY "anon_delete_files"  ON deliverable_files FOR DELETE TO anon USING (true);

-- ─── Storage bucket ───────────────────────────────────────────────────────────

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'student-portal',
  'student-portal',
  true,
  52428800,
  ARRAY[
    'image/jpeg','image/png','image/gif','image/webp',
    'application/pdf',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/msword',
    'application/vnd.ms-powerpoint',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation'
  ]
)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "public_read_storage" ON storage.objects
  FOR SELECT TO anon USING (bucket_id = 'student-portal');

CREATE POLICY "anon_upload_storage" ON storage.objects
  FOR INSERT TO anon WITH CHECK (bucket_id = 'student-portal');

CREATE POLICY "anon_delete_storage" ON storage.objects
  FOR DELETE TO anon USING (bucket_id = 'student-portal');
