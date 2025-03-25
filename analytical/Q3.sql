-- arguments:
--   name prefix (Ubisoft)
SELECT count(*) AS total, count(DISTINCT id) AS unique
FROM (
    (
        SELECT p.name, u.id
        FROM publisher p
        JOIN games_publishers gp ON gp.publisher_id = p.id
        JOIN game g ON g.id = gp.game_id
        JOIN library l ON l.game_id = g.id
        JOIN users u ON u.id = l.user_id
    )
    UNION ALL
    (
        SELECT d.name, u.id
        FROM developer d
        JOIN games_developers gd ON gd.developer_id = d.id
        JOIN game g ON g.id = gd.game_id
        JOIN library l ON l.game_id = g.id
        JOIN users u ON u.id = l.user_id 
    )
)
WHERE name LIKE 'Ubisoft%';
