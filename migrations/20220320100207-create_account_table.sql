
-- +migrate Up
CREATE TABLE accounts (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    password text NOT NULL,
    account_status smallint NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TRIGGER tr_accounts_updated_at
    BEFORE UPDATE ON accounts
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

-- +migrate Down
DROP TRIGGER IF EXISTS tr_accounts_updated_at on accounts;
DROP TABLE IF NOT EXISTS accounts;