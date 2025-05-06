-- Index to optimize search for friendships
IF NOT EXISTS CREATE INDEX idx_friendship_user_id_2 ON friendship (user_id_2);