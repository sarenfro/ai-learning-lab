-- Add mbaa@uw.edu as a portal admin (login only, not a co-organizer)
DROP POLICY IF EXISTS "portal_organizers_only" ON meetings;
DROP POLICY IF EXISTS "portal_organizers_only" ON meeting_attendees;
DROP POLICY IF EXISTS "portal_organizers_only" ON cohorts;

CREATE POLICY "portal_organizers_only" ON meetings
  FOR ALL
  USING (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu', 'mbaa@uw.edu'
  ))
  WITH CHECK (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu', 'mbaa@uw.edu'
  ));

CREATE POLICY "portal_organizers_only" ON meeting_attendees
  FOR ALL
  USING (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu', 'mbaa@uw.edu'
  ))
  WITH CHECK (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu', 'mbaa@uw.edu'
  ));

CREATE POLICY "portal_organizers_only" ON cohorts
  FOR ALL
  USING (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu', 'mbaa@uw.edu'
  ))
  WITH CHECK (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu', 'mbaa@uw.edu'
  ));
