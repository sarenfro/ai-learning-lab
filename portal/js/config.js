// Portal configuration — fill in your Supabase project values.
// The URL and anon key are PUBLIC credentials; they are safe in client-side code.
// IMPORTANT: After filling these in, do not commit this file with real values if
// you prefer not to expose them in git. The anon key is designed to be public,
// but add portal/js/config.js to .gitignore if you'd rather keep it out of source control.

var SUPABASE_URL = 'https://zlhzmyfbawmvwhiqldxt.supabase.co';
var SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpsaHpteWZiYXdtdndoanFsZHh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcwNjg1MDcsImV4cCI6MjA5MjY0NDUwN30.Q3AlsjU7DElYFC0kOVGv0tN5Vi8Eexftp6vH_5KBOPE';

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
// Additional accounts that can log in but are not co-organizers (won't receive meeting invites).
var PORTAL_ADMIN_EMAILS = ['mbaa@uw.edu'];

// Derived from co-organizers + admins — do not edit this separately.
var PORTAL_ALLOWED_EMAILS = PORTAL_CO_ORGANIZERS.map(function(p) {
  return p.email.toLowerCase();
}).concat(PORTAL_ADMIN_EMAILS);
