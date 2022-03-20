
-- +migrate Up
CREATE TABLE IF NOT EXISTS users (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    account uuid NOT NULL FOREIGN KEY REFERENCES accounts(id),
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TRIGGER tr_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

-- +migrate Down
DROP TRIGGER IF EXISTS tr_users_updated_at on users;
DROP TABLE IF EXISTS users;
