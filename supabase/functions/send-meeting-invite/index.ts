import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
  const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
  const brevoKey = Deno.env.get('BREVO_API_KEY')!

  const { meeting_id, test_mode } = await req.json();
  if (!meeting_id) {
    return new Response(JSON.stringify({ error: 'meeting_id is required' }), {
      status: 400,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }

  const admin = createClient(supabaseUrl, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  // Fetch meeting
  const { data: meeting, error: meetingErr } = await admin
    .from('meetings')
    .select('*')
    .eq('id', meeting_id)
    .single();

  if (meetingErr || !meeting) {
    return new Response(JSON.stringify({ error: 'Meeting not found' }), {
      status: 404,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }

  // Fetch attendees
  const { data: attendees } = await admin
    .from('meeting_attendees')
    .select('*')
    .eq('meeting_id', meeting_id);

  // Resolve organizer email from the meeting's created_by user
  let organizerEmail = 'mbaa@uw.edu';
  let organizerName = 'AI Learning Lab';
  if (meeting.created_by) {
    const { data: { user: creator } } = await admin.auth.admin.getUserById(meeting.created_by);
    if (creator?.email) {
      organizerEmail = creator.email;
      organizerName = creator.email;
    }
  }

  const subjectDate = formatSubjectDate(meeting.start_time);

  // test_mode: only send to the meeting creator, not all attendees
  const recipients = test_mode
    ? (attendees ?? []).filter((a) => a.email === organizerEmail)
    : (attendees ?? []);

  // ICS uses only the actual recipients so "Required" attendees match who got the invite
  const icsContent = generateIcs(meeting, recipients, organizerEmail, organizerName);
  const icsBase64 = encodeBase64(new TextEncoder().encode(icsContent));

  const errors: { email: string; error: string }[] = [];

  for (const attendee of recipients) {
    const payload = {
      sender: { name: 'AI Learning Lab', email: 'mbaa@uw.edu' },
      to: [{ name: attendee.name, email: attendee.email }],
      subject: `Invitation: ${meeting.title} on ${subjectDate}`,
      htmlContent: formatEmailHtml(meeting, attendee.name),
      textContent: formatEmailText(meeting),
      attachment: [
        {
          name: 'invite.ics',
          content: icsBase64,
          type: 'text/calendar',
        },
      ],
    };

    const res = await fetch('https://api.brevo.com/v3/smtp/email', {
      method: 'POST',
      headers: {
        'api-key': brevoKey,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    if (!res.ok) {
      const errText = await res.text();
      errors.push({ email: attendee.email, error: errText });
    }
  }

  return new Response(
    JSON.stringify({ success: true, sent: recipients.length, test_mode: !!test_mode, errors }),
    { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
  );
});

// ─── ICS generation ───────────────────────────────────────────────────────────

function generateIcs(
  meeting: Record<string, string>,
  attendees: Record<string, string>[],
  organizerEmail: string,
  organizerName: string,
): string {
  const lines: string[] = [
    'BEGIN:VCALENDAR',
    'VERSION:2.0',
    'PRODID:-//AI Learning Lab//Portal//EN',
    'CALSCALE:GREGORIAN',
    'METHOD:REQUEST',
    // VTIMEZONE block for America/Los_Angeles (handles PST/PDT automatically)
    'BEGIN:VTIMEZONE',
    'TZID:America/Los_Angeles',
    'BEGIN:STANDARD',
    'DTSTART:19701101T020000',
    'RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=11',
    'TZOFFSETFROM:-0700',
    'TZOFFSETTO:-0800',
    'TZNAME:PST',
    'END:STANDARD',
    'BEGIN:DAYLIGHT',
    'DTSTART:19700308T020000',
    'RRULE:FREQ=YEARLY;BYDAY=2SU;BYMONTH=3',
    'TZOFFSETFROM:-0800',
    'TZOFFSETTO:-0700',
    'TZNAME:PDT',
    'END:DAYLIGHT',
    'END:VTIMEZONE',
    'BEGIN:VEVENT',
    `UID:${meeting.ics_uid}`,
    `DTSTAMP:${formatDtUtc(new Date())}`,
    `DTSTART;TZID=America/Los_Angeles:${formatDtPt(meeting.start_time)}`,
    `DTEND;TZID=America/Los_Angeles:${formatDtPt(meeting.end_time)}`,
    `SUMMARY:${escapeIcs(meeting.title)}`,
    `ORGANIZER;CN="${escapeIcs(organizerName)}":mailto:${organizerEmail}`,
  ];

  if (meeting.description) {
    lines.push(`DESCRIPTION:${escapeIcs(meeting.description)}`);
  }
  const icsParts = [meeting.physical_location, meeting.location].filter(Boolean);
  if (icsParts.length) {
    lines.push(`LOCATION:${escapeIcs(icsParts.join(' | '))}`);
  }

  for (const a of attendees) {
    const role = a.role === 'co_organizer' ? 'CHAIR' : 'REQ-PARTICIPANT';
    lines.push(
      `ATTENDEE;ROLE=${role};RSVP=TRUE;CN="${escapeIcs(a.name)}":mailto:${a.email}`,
    );
  }

  lines.push('END:VEVENT', 'END:VCALENDAR');

  return lines.map(foldLine).join('\r\n') + '\r\n';
}

// RFC 5545 §3.1 — fold at 75 octets, continuation lines start with a single space
function foldLine(line: string): string {
  const encoder = new TextEncoder();
  const bytes = encoder.encode(line);
  if (bytes.length <= 75) return line;

  const decoder = new TextDecoder();
  const result: string[] = [];
  let pos = 0;
  let isFirst = true;

  while (pos < bytes.length) {
    const limit = isFirst ? 75 : 74; // account for leading space on continuation
    let end = Math.min(pos + limit, bytes.length);

    // Don't split in the middle of a multibyte UTF-8 sequence
    while (end > pos && (bytes[end] & 0xc0) === 0x80) end--;

    result.push((isFirst ? '' : ' ') + decoder.decode(bytes.slice(pos, end)));
    pos = end;
    isFirst = false;
  }

  return result.join('\r\n');
}

function escapeIcs(s: string): string {
  return s
    .replace(/\\/g, '\\\\')
    .replace(/;/g, '\\;')
    .replace(/,/g, '\\,')
    .replace(/\n/g, '\\n');
}

// DTSTAMP — always UTC per RFC 5545
function formatDtUtc(d: Date): string {
  const p = (n: number) => String(n).padStart(2, '0');
  return `${d.getUTCFullYear()}${p(d.getUTCMonth() + 1)}${p(d.getUTCDate())}T${p(d.getUTCHours())}${p(d.getUTCMinutes())}${p(d.getUTCSeconds())}Z`;
}

// DTSTART / DTEND — Pacific Time wall-clock value for use with TZID=America/Los_Angeles
function formatDtPt(iso: string): string {
  const d = new Date(iso);
  const parts = new Intl.DateTimeFormat('en-US', {
    timeZone: 'America/Los_Angeles',
    year: 'numeric', month: '2-digit', day: '2-digit',
    hour: '2-digit', minute: '2-digit', second: '2-digit',
    hour12: false,
  }).formatToParts(d);
  const get = (type: string) => parts.find((p) => p.type === type)!.value;
  const hour = get('hour') === '24' ? '00' : get('hour');
  return `${get('year')}${get('month')}${get('day')}T${hour}${get('minute')}${get('second')}`;
}

function formatSubjectDate(iso: string): string {
  return new Date(iso).toLocaleDateString('en-US', {
    month: 'long', day: 'numeric', year: 'numeric', timeZone: 'America/Los_Angeles',
  });
}

function ptDate(iso: string) {
  const d = new Date(iso);
  return {
    date: d.toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric', timeZone: 'America/Los_Angeles' }),
    time: d.toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit', timeZone: 'America/Los_Angeles' }),
  };
}

function formatEmailHtml(meeting: Record<string, string>, recipientName: string): string {
  const start = ptDate(meeting.start_time);
  const end = ptDate(meeting.end_time);

  const physicalRow = meeting.physical_location ? `
    <tr>
      <td style="padding:14px 24px;border-bottom:1px solid #e0dcf0;">
        <div style="font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:#5a5070;margin-bottom:4px;">Location</div>
        <div style="font-size:15px;color:#1c1230;">${escapeHtml(meeting.physical_location)}</div>
      </td>
    </tr>` : '';
  const locationRow = meeting.location ? `
    <tr>
      <td style="padding:14px 24px;border-bottom:1px solid #e0dcf0;">
        <div style="font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:#5a5070;margin-bottom:4px;">Virtual link</div>
        <div style="font-size:15px;"><a href="${escapeHtml(meeting.location)}" style="color:#4b2e83;">${escapeHtml(meeting.location)}</a></div>
      </td>
    </tr>` : '';

  const descriptionBlock = meeting.description ? `
    <p style="margin:0 0 24px;font-size:15px;color:#5a5070;line-height:1.7;white-space:pre-wrap;">${escapeHtml(meeting.description)}</p>` : '';

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="color-scheme" content="light">
  <meta name="supported-color-schemes" content="light">
  <style>
    :root { color-scheme: light; }
    @media (prefers-color-scheme: dark) {
      .header-cell { background-color: #2e1b5e !important; }
      .header-brand { color: #b7a57a !important; }
      .header-sub { color: rgba(255,255,255,0.75) !important; }
      .body-cell { background-color: #ffffff !important; }
      .footer-cell { background-color: #f2eefa !important; }
      .title { color: #2e1b5e !important; }
      .label { color: #5a5070 !important; }
      .value { color: #1c1230 !important; }
    }
  </style>
</head>
<body style="margin:0;padding:0;background:#f2eefa;font-family:Arial,Helvetica,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#f2eefa;padding:40px 16px;">
    <tr><td align="center">
      <table width="600" cellpadding="0" cellspacing="0" style="max-width:600px;width:100%;">

        <!-- Header -->
        <tr>
          <td class="header-cell" style="background-color:#2e1b5e !important;border-bottom:3px solid #b7a57a;padding:24px 32px;border-radius:8px 8px 0 0;">
            <div class="header-brand" style="color:#b7a57a !important;font-size:10px;font-weight:700;letter-spacing:0.12em;text-transform:uppercase;margin-bottom:6px;">AI Learning Lab</div>
            <div class="header-sub" style="color:rgba(255,255,255,0.75) !important;font-size:13px;">Foster School of Business &middot; University of Washington</div>
          </td>
        </tr>

        <!-- Body -->
        <tr>
          <td style="background:#ffffff;padding:36px 32px;border-radius:0;">

            <div style="font-size:11px;font-weight:700;letter-spacing:0.1em;text-transform:uppercase;color:#b7a57a;margin-bottom:10px;">Meeting Invitation</div>
            <h1 style="margin:0 0 28px;font-size:26px;font-weight:700;color:#2e1b5e;line-height:1.2;">${escapeHtml(meeting.title)}</h1>

            <!-- Details table -->
            <table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #e0dcf0;border-radius:6px;margin-bottom:28px;">
              <tr>
                <td style="padding:14px 24px;border-bottom:1px solid #e0dcf0;">
                  <div style="font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:#5a5070;margin-bottom:4px;">Date</div>
                  <div style="font-size:15px;color:#1c1230;">${start.date}</div>
                </td>
              </tr>
              <tr>
                <td style="padding:14px 24px;border-bottom:1px solid #e0dcf0;">
                  <div style="font-size:11px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;color:#5a5070;margin-bottom:4px;">Time</div>
                  <div style="font-size:15px;color:#1c1230;">${start.time} &ndash; ${end.time} PT</div>
                </td>
              </tr>
              ${physicalRow}
              ${locationRow}
            </table>

            ${descriptionBlock}

            <p style="margin:0;font-size:14px;color:#8a84a0;line-height:1.6;">A calendar file is attached. Open it to add this event to your calendar.</p>
          </td>
        </tr>

        <!-- Footer -->
        <tr>
          <td style="background:#f2eefa;padding:20px 32px;border-top:1px solid #e0dcf0;border-radius:0 0 8px 8px;">
            <p style="margin:0;font-size:12px;color:#8a84a0;">AI Learning Lab &middot; Foster School of Business &middot; University of Washington</p>
          </td>
        </tr>

      </table>
    </td></tr>
  </table>
</body>
</html>`;
}

function formatEmailText(meeting: Record<string, string>): string {
  const start = ptDate(meeting.start_time);
  const end = ptDate(meeting.end_time);
  let body = `${meeting.title}\n\n`;
  body += `Date:  ${start.date}\n`;
  body += `Time:  ${start.time} – ${end.time} PT\n`;
  if (meeting.physical_location) body += `Location: ${meeting.physical_location}\n`;
  if (meeting.location) body += `Virtual:  ${meeting.location}\n`;
  if (meeting.description) body += `\n${meeting.description}\n`;
  body += '\nA calendar file (.ics) is attached. Open it to add this event to your calendar.';
  return body;
}

function escapeHtml(s: string): string {
  return (s ?? '').replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

// Uint8Array → base64 string (safe for large buffers)
function encodeBase64(bytes: Uint8Array): string {
  let binary = '';
  for (let i = 0; i < bytes.length; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return btoa(binary);
}
