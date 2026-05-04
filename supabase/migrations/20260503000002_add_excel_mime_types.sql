-- Add Excel MIME types to the student-portal storage bucket.
-- Images were already present; this extends the allowed list to include
-- .xls and .xlsx so students can upload spreadsheets.

UPDATE storage.buckets
SET allowed_mime_types = array_cat(
  allowed_mime_types,
  ARRAY[
    'application/vnd.ms-excel',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  ]
)
WHERE id = 'student-portal'
  AND NOT (allowed_mime_types @> ARRAY['application/vnd.ms-excel']);
