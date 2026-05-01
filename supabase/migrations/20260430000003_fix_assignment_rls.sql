-- Fix organizer_manage_assignments to include all portal admin emails.
-- Previously only had 4 emails; sarrah.renfro@gmail.com and sarrah.truong@gmail.com
-- could log in (via PORTAL_ADMIN_EMAILS) but were blocked by RLS on INSERT/DELETE.

DROP POLICY IF EXISTS "organizer_manage_assignments" ON student_assignments;

CREATE POLICY "organizer_manage_assignments" ON student_assignments
  FOR ALL
  USING (auth.jwt() ->> 'email' IN (
    'russ@speycast.com',
    'colettev@uw.edu',
    'sarenfro@uw.edu',
    'mbaa@uw.edu',
    'sarrah.renfro@gmail.com',
    'sarrah.truong@gmail.com'
  ))
  WITH CHECK (auth.jwt() ->> 'email' IN (
    'russ@speycast.com',
    'colettev@uw.edu',
    'sarenfro@uw.edu',
    'mbaa@uw.edu',
    'sarrah.renfro@gmail.com',
    'sarrah.truong@gmail.com'
  ));
