-- Add profile fields to student_assignments for display in company portal

ALTER TABLE student_assignments
  ADD COLUMN IF NOT EXISTS graduating_class text DEFAULT '',
  ADD COLUMN IF NOT EXISTS linkedin_url     text DEFAULT '',
  ADD COLUMN IF NOT EXISTS resume_url       text DEFAULT '';

-- Allow any authenticated user (company contacts) to read all student assignments.
-- Consistent with auth_read_deliverables pattern.
CREATE POLICY "auth_read_assignments" ON student_assignments
  FOR SELECT TO authenticated USING (true);

-- Allow students to update their own profile fields.
CREATE POLICY "student_update_own_profile" ON student_assignments
  FOR UPDATE TO authenticated
  USING  (lower(student_email) = lower(auth.jwt() ->> 'email'))
  WITH CHECK (lower(student_email) = lower(auth.jwt() ->> 'email'));
