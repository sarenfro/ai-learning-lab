-- AI Learning Lab Portal — Initial Schema
-- Run this entire block in Supabase Dashboard > SQL Editor

-- ─── Tables ──────────────────────────────────────────────────────────────────

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
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  meeting_id  uuid        REFERENCES meetings(id) ON DELETE CASCADE,
  name        text        NOT NULL,
  email       text        NOT NULL,
  role        text        NOT NULL CHECK (role IN ('organizer', 'co_organizer', 'attendee')),
  added_at    timestamptz DEFAULT now()
);

-- ─── Row-Level Security ───────────────────────────────────────────────────────

ALTER TABLE meetings          ENABLE ROW LEVEL SECURITY;
ALTER TABLE meeting_attendees ENABLE ROW LEVEL SECURITY;

-- Only these three organizer emails can read/write meetings and attendees.
-- To add or remove someone, update the email list in both policies below.
CREATE POLICY "portal_organizers_only" ON meetings
  FOR ALL
  USING (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu'
  ))
  WITH CHECK (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu'
  ));

CREATE POLICY "portal_organizers_only" ON meeting_attendees
  FOR ALL
  USING (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu'
  ))
  WITH CHECK (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu'
  ));
