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
    twofa_confirmed BOOLEAN DEFAULT FALSE, -- whether new secret was confirmed by inputting a code
    privilege_level INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    webauthn_credential_id TEXT,
    webauthn_public_key TEXT,
    webauthn_challenge TEXT, -- should be used only temporarily
    webauthn_user_id TEXT
    );

-- INSERT INTO users(username, email, password_hash, privilege_level) VALUES('admin', 'admin@example.com', 'wronghash', 2);

CREATE TABLE IF NOT EXISTS communities(
    community_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    url TEXT UNIQUE NOT NULL,
    owner_user_id INT NOT NULL REFERENCES users(user_id)
);

