-- Indexes used for better performance of the query
CREATE INDEX idx_developer_name ON developer(name text_pattern_ops);
CREATE INDEX idx_publisher_name ON publisher(name text_pattern_ops);
CREATE INDEX idx_library_game_user ON library(game_id, user_id);


-- possiveis parametros a dar tunning para reduzir o tempo do parallel scan 
--SET max_parallel_workers_per_gather = 4;
--SET parallel_tuple_cost = 0.1;
--SET parallel_setup_cost = 1000;

-- arguments:
--   name prefix (Ubisoft)
EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*) AS total, count(DISTINCT l.user_id) AS unique
FROM library l
WHERE l.game_id IN (
    SELECT gp.game_id
    FROM publisher p
    JOIN games_publishers gp ON gp.publisher_id = p.id
    WHERE p.name LIKE 'Ubisoft%'
    
    UNION ALL
    
    SELECT gd.game_id
    FROM developer d
    JOIN games_developers gd ON gd.developer_id = d.id
    WHERE d.name LIKE 'Ubisoft%'
);
