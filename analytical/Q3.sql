-- Indexes used for better performance of the query
CREATE INDEX idx_developer_name ON developer(name text_pattern_ops);
CREATE INDEX idx_publisher_name ON publisher(name text_pattern_ops);
CREATE INDEX idx_games_publishers_pubid_gameid ON games_publishers (publisher_id, game_id);
CREATE INDEX idx_games_developers_devid_gameid ON games_developers (developer_id, game_id);
CREATE INDEX idx_library_game_user_including ON library (game_id, user_id) INCLUDE (user_id);

-- correr cada vez que entrarmos no psql
SET work_mem = '128MB'; -- Melhores valores: 128MB, 256MB

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
