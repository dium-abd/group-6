-- arguments:
--   lower date (2020-01-01)
--   bin length (12 hours)
EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS)
SELECT * 
FROM library_12h_summary 
WHERE bin >= '2020-03-29'
ORDER BY bin;


-- V2
--
SELECT
    date_bin('12 hours', added_date, '2003-09-12') AS bin,
    count(*) FILTER (WHERE buy_price > 0) AS paid_copies,
    count(*) FILTER (WHERE buy_price = 0) AS free_copies,
    sum(buy_price) AS money_generated
FROM library
WHERE added_date >= '2020-01-01'
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
