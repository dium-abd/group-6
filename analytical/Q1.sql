
-- QUERY ORIGINAL

SELECT year, id, name, sales
FROM (
    SELECT year, id, name, sales,
        rank() OVER (PARTITION BY year ORDER BY sales DESC) AS rank
    FROM (
        SELECT l.year, g.id, g.name, count(*) AS sales
        FROM game g
        JOIN (
            SELECT extract(year FROM added_date) AS year, game_id
            FROM library
        ) l ON l.game_id = g.id
        WHERE price > 0
        GROUP BY 1, 2, 3
    )
)
WHERE rank = 1
ORDER BY year DESC;



-- QUERY FINAL
-- Fazemos query na tabela top_sales_game_per_year para todos os anos
-- e adicionamos o ano atual com o jogo mais vendido
Select * FROM top_sales_game_per_year
UNION ALL
SELECT EXTRACT(YEAR FROM CURRENT_DATE)::INT AS year, game_id, game_name, sales
FROM (
  SELECT game_id, game_name, sales
  FROM sales_currentyear
  ORDER BY sales DESC
  LIMIT 1
) t
ORDER BY year DESC;
