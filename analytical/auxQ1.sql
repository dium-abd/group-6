DO $$
BEGIN
    -- Verify if the table exists
    IF NOT EXISTS (
        SELECT FROM information_schema.tables
        WHERE table_schema = 'public'
        AND table_name = 'sales_per_game_year'
    ) THEN
        -- Create the table
        CREATE TABLE sales_per_game_year (
            year INTEGER NOT NULL,
            game_id INTEGER NOT NULL,
            game_name TEXT NOT NULL,
            sales INTEGER NOT NULL,
            PRIMARY KEY (year, game_id)
        );

        -- Insert aggregated data
        INSERT INTO sales_per_game_year (year, game_id, game_name, sales)
        SELECT 
            EXTRACT(YEAR FROM l.added_date)::INT AS year,
            g.id,
            g.name,
            COUNT(*) AS sales
        FROM library l
        JOIN game g ON l.game_id = g.id
        WHERE g.price > 0
        GROUP BY year, g.id, g.name;

        -- Create Index
        CREATE INDEX idx_sales_order_year_sales
        ON sales_per_game_year (year DESC, sales DESC);
    END IF;
END
$$;
