DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM information_schema.tables
        WHERE table_schema = 'public' 
          AND table_name = 'company_users_count'
    ) THEN
        -- Create the table
        CREATE TABLE company_users_count (
            company_name VARCHAR PRIMARY KEY,
            total_users INTEGER,
            unique_users INTEGER
        );

        -- Populate the table
        INSERT INTO company_users_count (company_name, total_users, unique_users)
        SELECT 
            g.name AS company_name, 
            count(*) AS total_users, 
            count(DISTINCT l.user_id) AS unique_users
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
    END IF;
END
$$;
