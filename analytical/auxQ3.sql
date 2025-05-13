-- This script creates a new table to store the count of users for each company
-- and updates it whenever a new game is added to the library.

DROP TABLE IF EXISTS company_users_count;

-- Create the table
CREATE TABLE company_users_count (
    company_name VARCHAR PRIMARY KEY,
    total_users INTEGER NOT NULL DEFAULT 0,
    unique_users INTEGER NOT NULL DEFAULT 0
);

-- Populate the table from existing data
INSERT INTO company_users_count (company_name, total_users, unique_users)
SELECT 
    g.name AS company_name, 
    COUNT(*) AS total_users, 
    COUNT(DISTINCT l.user_id) AS unique_users
FROM (
    SELECT p.name, gp.game_id
    FROM publisher p
    JOIN games_publishers gp ON gp.publisher_id = p.id
    
    UNION ALL
    
    SELECT d.name, gd.game_id
    FROM developer d
    JOIN games_developers gd ON gd.developer_id = d.id
) AS g
JOIN library l ON l.game_id = g.game_id
GROUP BY g.name;


CREATE OR REPLACE FUNCTION update_company_users_count() 
RETURNS TRIGGER AS $$
BEGIN
    WITH companies AS (
        SELECT p.name AS company_name
        FROM publisher p
        JOIN games_publishers gp ON gp.publisher_id = p.id
        WHERE gp.game_id = NEW.game_id
        UNION ALL
        SELECT d.name AS company_name
        FROM developer d
        JOIN games_developers gd ON gd.developer_id = d.id
        WHERE gd.game_id = NEW.game_id
    ),
    company_counts AS (
        SELECT company_name, COUNT(*) AS appearances
        FROM companies
        GROUP BY company_name
    ),
    new_uniques AS (
        SELECT cc.company_name
        FROM company_counts cc
        WHERE NOT EXISTS (
            SELECT 1
            FROM (
                SELECT p.name AS company_name, gp.game_id
                FROM publisher p
                JOIN games_publishers gp ON gp.publisher_id = p.id
                WHERE p.name = cc.company_name
                UNION ALL
                SELECT d.name AS company_name, gd.game_id
                FROM developer d
                JOIN games_developers gd ON gd.developer_id = d.id
                WHERE d.name = cc.company_name
            ) company_games
            JOIN library l ON l.game_id = company_games.game_id
            WHERE l.user_id = NEW.user_id
              AND l.game_id <> NEW.game_id -- exclude the game just added
        )
    )
    UPDATE company_users_count cuc
    SET 
        total_users = cuc.total_users + cc.appearances,
        unique_users = cuc.unique_users + 
            (CASE WHEN cuc.company_name IN (SELECT company_name FROM new_uniques) THEN 1 ELSE 0 END)
    FROM company_counts cc
    WHERE cuc.company_name = cc.company_name;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Ensure the trigger doesn't get created multiple times
DROP TRIGGER IF EXISTS trg_update_company_users_count ON library;

CREATE TRIGGER trg_update_company_users_count
AFTER INSERT ON library
FOR EACH ROW
EXECUTE FUNCTION update_company_users_count();
