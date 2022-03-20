
-- +migrate Up

CREATE TYPE account_status AS ENUM ('active', 'blocked', 'archived', 'unknown');
CREATE TYPE account_category AS ENUM ('normal', 'premium');

CREATE TABLE account (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    status account_status NOT NULL,
    category account_category NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE account_audit (
    audit_id uuid PRIMARY KEY,
    audit_operation varchar(255) NOT NULL,
    audit_time timestamp NOT NULL,
    audit_user varchar(255) NOT NULL,
    id uuid PRIMARY KEY,
    account_status smallint NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TRIGGER tr_account_updated_at
    BEFORE UPDATE ON account
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

CREATE TRIGGER tr_account_audit
    AFTER INSERT OR UPDATE OR DELETE ON account
    FOR EACH ROW
    EXECUTE PROCEDURE audit_trigger();

-- +migrate Down
DROP TRIGGER IF EXISTS tr_account_updated_at on account;
DROP TABLE IF NOT EXISTS account;

DROP TRIGGER IF EXISTS tr_account_audit_updated_at on account;
DROP TABLE IF NOT EXISTS account_audit;
