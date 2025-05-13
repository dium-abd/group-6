CREATE INDEX IF NOT EXISTS index_library_game_playtime ON library(game_id, playtime DESC) WHERE playtime > 0;
CREATE INDEX IF NOT EXISTS index_users_vac_banned ON users(id) WHERE NOT vac_banned;