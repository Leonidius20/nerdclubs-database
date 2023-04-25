CREATE TABLE IF NOT EXISTS privilege_levels(
    privilege_level_id SERIAL PRIMARY KEY,
    privilege_name TEXT UNIQUE NOT NULL
);

--INSERT INTO privilege_levels(privilege_name) VALUES('user'), ('full_admin');

CREATE TABLE IF NOT EXISTS users(
    user_id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    twofa_secret TEXT,
    privilege_level INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users(username, email, password_hash, privilege_level) VALUES('admin', 'admin@example.com', 'wronghash', 2);