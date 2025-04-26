-- Indexes used for better performance of the query
CREATE INDEX idx_developer_name ON developer(name text_pattern_ops);
CREATE INDEX idx_publisher_name ON publisher(name text_pattern_ops);

-- arguments:
--   name prefix (Ubisoft)
EXPLAIN (ANALYZE, BUFFERS) SELECT count(*) AS total, count(DISTINCT id) AS unique
FROM (
    (
        SELECT p.name, l.user_id AS id
        FROM publisher p
        JOIN games_publishers gp ON gp.publisher_id = p.id
        JOIN game g ON g.id = gp.game_id
        JOIN library l ON l.game_id = g.id
    )
    UNION ALL
    (
        SELECT d.name, l.user_id AS id
        FROM developer d
        JOIN games_developers gd ON gd.developer_id = d.id
        JOIN game g ON g.id = gd.game_id
        JOIN library l ON l.game_id = g.id
    )
)
WHERE name LIKE 'Ubisoft%';
