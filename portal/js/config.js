// Portal configuration — fill in your Supabase project values.
// The URL and anon key are PUBLIC credentials; they are safe in client-side code.
// IMPORTANT: After filling these in, do not commit this file with real values if
// you prefer not to expose them in git. The anon key is designed to be public,
// but add portal/js/config.js to .gitignore if you'd rather keep it out of source control.

var SUPABASE_URL = 'https://uwfkquukobhvguobirkr.supabase.co';
var SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV3ZmtxdXVrb2Jodmd1b2JpcmtyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY2MzQ3ODUsImV4cCI6MjA5MjIxMDc4NX0.3SVgiB3j1RdM0YX03Qsj-9NnqjKIAaca5jOBhDWRYCo';

// Default location pre-filled on new meetings — override per meeting as needed.
var PORTAL_DEFAULT_LOCATION = 'https://washington.zoom.us/my/sarenfro';

// These are the three co-organizers. They are automatically added to every meeting
// as locked attendees and are the only people allowed to log in.
var PORTAL_CO_ORGANIZERS = [
  { name: 'Russ Mann',     email: 'russ@speycast.com' },
  { name: 'Colette Vogel', email: 'colettev@uw.edu'   },
  { name: 'Sarah Renfro',  email: 'sarenfro@uw.edu'   }
];

// Derived from co-organizers — do not edit this separately.
var PORTAL_ALLOWED_EMAILS = PORTAL_CO_ORGANIZERS.map(function(p) {
  return p.email.toLowerCase();
});
