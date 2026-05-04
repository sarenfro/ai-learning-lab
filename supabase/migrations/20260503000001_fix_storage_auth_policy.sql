-- Storage bucket upload/delete policies for authenticated students.
-- The original migration only granted INSERT/DELETE to the `anon` role,
-- but students use Supabase magic-link auth so their requests arrive as
-- `authenticated`. This migration adds the missing policies.
-- Written idempotently in case policies were applied manually.

DROP POLICY IF EXISTS "auth_upload_storage" ON storage.objects;
DROP POLICY IF EXISTS "auth_update_storage" ON storage.objects;
DROP POLICY IF EXISTS "auth_delete_storage" ON storage.objects;

CREATE POLICY "auth_upload_storage" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (bucket_id = 'student-portal');

CREATE POLICY "auth_update_storage" ON storage.objects
  FOR UPDATE TO authenticated
  USING (bucket_id = 'student-portal');

CREATE POLICY "auth_delete_storage" ON storage.objects
  FOR DELETE TO authenticated
  USING (bucket_id = 'student-portal');
