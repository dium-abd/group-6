
SET max_parallel_workers_per_gather = 0;

-- Query final:
--
-- arguments:
--   game id (730)
SELECT u.id, u.username, u.country, (l.playtime / 60)::int AS hours, l.added_date
FROM library l
JOIN users u ON u.id = l.user_id AND NOT u.vac_banned
WHERE l.game_id = 730 AND l.playtime > 0
ORDER BY l.playtime DESC, l.added_date DESC
LIMIT 1000;


-- Query original:
--
--SELECT u.id, u.username, u.country, (l.playtime / 60)::int AS hours, l.added_date
--FROM game g
--JOIN library l ON l.game_id = g.id
--JOIN users u ON u.id = l.user_id
--WHERE g.id = 730
--    AND l.playtime > 0
--    AND NOT u.vac_banned
--ORDER BY 4 DESC, 5 DESC
--LIMIT 1000;
