CREATE TABLE IF NOT EXISTS top_sales_game_per_year (
  year       INTEGER PRIMARY KEY,
  game_id    INTEGER NOT NULL,
  game_name  TEXT,
  sales      INTEGER
);

 INSERT INTO top_sales_game_per_year (year, game_id, game_name, sales)
  SELECT year, game_id, game_name, sales
  FROM (
    SELECT EXTRACT(YEAR FROM l.added_date) AS year,
           l.game_id,
           g.name AS game_name,
           COUNT(*) AS sales,
           ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM l.added_date) ORDER BY COUNT(*) DESC) AS rn
    FROM library l
    JOIN game g ON l.game_id = g.id
    WHERE EXTRACT(YEAR FROM l.added_date) <= 2024
      AND g.price > 0
    GROUP BY EXTRACT(YEAR FROM l.added_date), l.game_id, g.name
  ) t
  WHERE rn = 1;

CREATE TABLE IF NOT EXISTS sales_currentYear (
  game_id    INTEGER PRIMARY KEY,
  game_name  TEXT,
  sales      INTEGER
);

INSERT INTO sales_currentYear (game_id, game_name, sales)
SELECT
  g.id,
  g.name,
  COUNT(*) AS sales
FROM library l
JOIN game g ON l.game_id = g.id
WHERE EXTRACT(YEAR FROM l.added_date) = EXTRACT(YEAR FROM CURRENT_DATE)
  AND g.price > 0
GROUP BY g.id, g.name;

CREATE INDEX IF NOT EXISTS index_sales_currentyear_sales_desc ON sales_currentYear (sales DESC);
VACUUM ANALYZE sales_currentYear;

CREATE OR REPLACE FUNCTION update_sales_current_year()
RETURNS TRIGGER AS $$
BEGIN
  IF (SELECT price FROM game WHERE id = NEW.game_id) > 0 THEN
    UPDATE sales_currentYear
    SET sales = sales + 1
    WHERE game_id = NEW.game_id;

    IF NOT FOUND THEN
      INSERT INTO sales_currentYear (game_id, game_name, sales)
      SELECT g.id, g.name, 1
      FROM game g
      WHERE g.id = NEW.game_id;
    END IF;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_sales_current_year ON library;

CREATE TRIGGER trg_update_sales_current_year
AFTER INSERT ON library
FOR EACH ROW
EXECUTE FUNCTION update_sales_current_year();
