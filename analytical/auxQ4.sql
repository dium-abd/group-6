CREATE MATERIALIZED VIEW library_12h_summary AS
SELECT
  date_bin('12 hours', added_date, '2003-09-12') AS bin,
  count(*) FILTER (WHERE buy_price > 0) AS paid_copies,
  count(*) FILTER (WHERE buy_price = 0) AS free_copies,
  sum(buy_price) AS money_generated
FROM library
WHERE added_date >= '2020-01-01'
GROUP BY bin
ORDER BY bin;


-- UNIQUE required by the refresh concurrently
CREATE UNIQUE INDEX ON library_12h_summary (bin);

-- This will refresh the materialized view immediately.
-- CONCURRENTLY requires an UNIQUE index on the view.
REFRESH MATERIALIZED VIEW CONCURRENTLY library_12h_summary;

-- Set an automated refresh every 12 hours
CREATE EXTENSION IF NOT EXISTS pg_cron;
SELECT cron.schedule(
  'refresh_library_summary_every_12h',        -- job name
  '0 */12 * * *',                             -- cron schedule: every 12 hours
  $$REFRESH MATERIALIZED VIEW CONCURRENTLY library_12h_summary;$$
);


-- Optionals: 
-- check the job
--SELECT * FROM cron.job;
-- remove the job
--SELECT cron.unschedule(jobid) FROM cron.job WHERE jobname = 'refresh_library_summary_every_12h';
