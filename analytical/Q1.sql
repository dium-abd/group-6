
-- QUERY ORIGINAL

-- SELECT year, id, name, sales
-- FROM (
--     SELECT year, id, name, sales,
--         rank() OVER (PARTITION BY year ORDER BY sales DESC) AS rank
--     FROM (
--         SELECT l.year, g.id, g.name, count(*) AS sales
--         FROM game g
--         JOIN (
--             SELECT extract(year FROM added_date) AS year, game_id
--             FROM library
--         ) l ON l.game_id = g.id
--         WHERE price > 0
--         GROUP BY 1, 2, 3
--     )
-- )
-- WHERE rank = 1
-- ORDER BY year DESC;

-- Consulta otimizada com DISTINCT ON
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT DISTINCT ON (year)
    year,
    game_id,
    game_name,
    sales
FROM sales_per_game_year
ORDER BY year DESC, sales DESC;




