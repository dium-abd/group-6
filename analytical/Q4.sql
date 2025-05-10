-- This is important for the generate_series function to work correctly
SET TIME ZONE 'UTC';

-- arguments:
--   lower date (2020-01-01)
--   bin length (12 hours)
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS)
WITH binned_library AS (
  SELECT
    date_bin('12 hours', added_date, '2020-01-01') AS bin,
    buy_price
  FROM library
  WHERE added_date >= '2020-01-01'
)
SELECT
  bin,
  count(*) FILTER (WHERE buy_price > 0) AS paid_copies,
  count(*) FILTER (WHERE buy_price = 0) AS free_copies,
  sum(buy_price) AS money_generated
FROM binned_library
GROUP BY bin
ORDER BY bin;


-- Query original
--
WITH bins AS (
    SELECT generate_series('2003-09-12', now(), '12 hours') AS bin
)
SELECT bin,
    count(*) FILTER (WHERE buy_price > 0) AS paid_copies,
    count(*) FILTER (WHERE buy_price = 0) AS free_copies,
    sum(buy_price) AS money_generated
FROM bins
JOIN library ON bin = date_bin('12 hours', added_date, '2020-01-01')
WHERE bin >= '2020-01-01'
GROUP BY bin
ORDER BY bin;
