
-- +migrate Up
CREATE TABLE user (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    account_id uuid NOT NULL REFERENCES account(id),
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);


CREATE TABLE user_audit (
    audit_id uuid PRIMARY KEY,
    audit_operation varchar(255) NOT NULL,
    audit_time timestamp NOT NULL,
    audit_user varchar(255) NOT NULL,
    id uuid NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    account_id uuid NOT NULL REFERENCES account(id),
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);


CREATE TRIGGER tr_user_updated_at
    BEFORE UPDATE ON user
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

CREATE TRIGGER tr_user_audit
    AFTER INSERT OR UPDATE OR DELETE ON user
    FOR EACH ROW
    EXECUTE PROCEDURE audit_trigger();


-- +migrate Down
DROP TRIGGER IF EXISTS tr_user_updated_at on user;
DROP TABLE IF EXISTS user;

DROP TRIGGER IF EXISTS tr_user_audit_updated_at on user;
DROP TABLE IF NOT EXISTS user_audit;