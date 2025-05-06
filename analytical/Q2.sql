-- arguments:
--   target user id (3331100)
EXPLAIN (ANALYZE, BUFFERS)
WITH args AS (
    SELECT 3331100 AS id
),
friends AS (
    SELECT 
        CASE 
            WHEN f.user_id_1 = args.id THEN f.user_id_2
            ELSE f.user_id_1
        END AS friend_id
    FROM friendship f, args
    WHERE f.user_id_1 = args.id OR f.user_id_2 = args.id
)
SELECT g.id, g.name
FROM friends f
JOIN library l ON f.friend_id = l.user_id
JOIN game g ON g.id = l.game_id
WHERE NOT EXISTS (
    SELECT 1
    FROM library lib, args
    WHERE lib.user_id = args.id
    AND lib.game_id = g.id
)
GROUP BY 1, 2
ORDER BY count(*) DESC
LIMIT 15;


--WITH args AS (
--    SELECT 3331100 AS id
--)
--SELECT g.id, g.name
--FROM game g
--JOIN library l ON l.game_id = g.id
--JOIN (
--    SELECT u.id
--    FROM args
--    JOIN users u ON true
--    JOIN friendship f
--        ON (f.user_id_1 = u.id AND f.user_id_2 = args.id) 
--        OR (f.user_id_1 = args.id AND f.user_id_2 = u.id)
--    WHERE u.id <> args.id
--) u ON u.id = l.user_id
--WHERE (
--    SELECT count(*) = 0
--    FROM args
--    JOIN library ON library.user_id = args.id
--    JOIN game ON game.id = library.game_id
--    WHERE game.id = g.id
--)
--GROUP BY 1, 2
--ORDER BY count(*) DESC
--LIMIT 15;
