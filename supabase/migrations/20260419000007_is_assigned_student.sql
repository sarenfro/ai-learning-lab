-- Gate student portal login on student_assignments instead of cohort membership.
-- SECURITY DEFINER so anon callers can check without bypassing RLS on the table.

CREATE OR REPLACE FUNCTION is_assigned_student(p_email text)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM student_assignments WHERE lower(student_email) = lower(p_email)
  );
$$;
