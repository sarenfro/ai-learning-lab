CREATE TABLE cohorts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  members jsonb NOT NULL DEFAULT '[]',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE cohorts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "portal_organizers_only" ON cohorts
  FOR ALL
  USING (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu'
  ))
  WITH CHECK (auth.jwt() ->> 'email' IN (
    'russ@speycast.com', 'colettev@uw.edu', 'sarenfro@uw.edu'
  ));
