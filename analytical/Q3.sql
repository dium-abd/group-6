-- correr cada vez que entrarmos no psql
SET work_mem = '128MB'; -- Testar melhores tempos

-- arguments:
--   name prefix (Ubisoft)
EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*) AS total, count(DISTINCT l.user_id) AS unique
FROM library l
WHERE l.game_id IN (
    SELECT gp.game_id
    FROM publisher p
    JOIN games_publishers gp ON gp.publisher_id = p.id
    WHERE p.name = 'Ubisoft'
    
    UNION ALL
    
    SELECT gd.game_id
    FROM developer d
    JOIN games_developers gd ON gd.developer_id = d.id
    WHERE d.name = 'Ubisoft'
);
