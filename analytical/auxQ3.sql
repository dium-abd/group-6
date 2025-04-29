-- Indexes used for better performance of the query
CREATE INDEX idx_developer_name ON developer(name);
CREATE INDEX idx_publisher_name ON publisher(name);
CREATE INDEX idx_games_publishers_pubid_gameid ON games_publishers (publisher_id, game_id);
CREATE INDEX idx_games_developers_devid_gameid ON games_developers (developer_id, game_id);
CREATE INDEX idx_library_game_user_including ON library (game_id, user_id) INCLUDE (user_id);

-- tabela adicional para guardar o numero de users que comprou jogos de cada empresa
--CREATE TABLE company_users_count (
--    company_name VARCHAR PRIMARY KEY,
--    total_users INTEGER,
--    distinct_users INTEGER
--)
-- ver como usar isto (é preciso popular a tabela e atualizar a cada compra,etc)