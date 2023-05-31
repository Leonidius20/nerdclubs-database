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

-- categories of posts in a community
CREATE TABLE IF NOT EXISTS categories(
    category_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    community_id INT NOT NULL REFERENCES communities,
    description TEXT
);


CREATE TABLE IF NOT EXISTS posts(
    post_id SERIAL PRIMARY KEY,
    community_id INT NOT NULL REFERENCES communities,
    author_user_id INT NOT NULL REFERENCES users(user_id),
    category_id INT NOT NULL REFERENCES categories,
    content TEXT NOT NULL,
    title TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- moderators logic
CREATE TABLE IF NOT EXISTS moderators(
    user_id INT NOT NULL REFERENCES users ON DELETE CASCADE,
    community_id INT NOT NULL REFERENCES communities ON DELETE CASCADE,
    PRIMARY KEY(user_id, community_id)
);

-- post upvotes/downvotes
CREATE TABLE IF NOT EXISTS post_votes(
    user_id INT NOT NULL REFERENCES users ON DELETE CASCADE,
    post_id INT NOT NULL REFERENCES posts ON DELETE CASCADE,
    is_positive BOOLEAN NOT NULL,
    PRIMARY KEY(user_id, post_id)
);

-- post comments
CREATE TABLE IF NOT EXISTS comments(
    comment_id SERIAL PRIMARY KEY,
    author_user_id INT NOT NULL REFERENCES users ON DELETE CASCADE,
    post_id INT NOT NULL REFERENCES posts,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    parent_comment_id INT REFERENCES comments ON DELETE CASCADE
);

-- comment upvotes/downvotes
CREATE TABLE IF NOT EXISTS comment_votes(
    user_id INT NOT NULL REFERENCES users ON DELETE CASCADE,
    comment_id INT NOT NULL REFERENCES comments ON DELETE CASCADE,
    is_positive BOOLEAN NOT NULL,
    PRIMARY KEY(user_id, comment_id)
);

-- wiki pages
CREATE TABLE IF NOT EXISTS wiki_pages(
    wiki_page_id SERIAL PRIMARY KEY,
    community_id INT NOT NULL REFERENCES communities ON DELETE CASCADE,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    url TEXT NOT NULL, 
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(community_id, url) -- url has to be unique within a community
);

-- wiki page version
CREATE TABLE IF NOT EXISTS wiki_page_versions(
    wiki_page_version_id SERIAL PRIMARY KEY,
    wiki_page_id INT NOT NULL REFERENCES wiki_pages ON DELETE CASCADE,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    last_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_editor_user_id INT NOT NULL REFERENCES users ON DELETE SET NULL
);