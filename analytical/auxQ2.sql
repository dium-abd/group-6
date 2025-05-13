-- Index to optimize search for friendships
CREATE INDEX IF NOT EXISTS idx_friendship_user_id_2 ON friendship (user_id_2);
VACUUM ANALYZE friendship;