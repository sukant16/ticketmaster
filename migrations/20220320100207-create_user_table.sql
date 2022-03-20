
-- +migrate Up
CREATE TABLE users (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    username text NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    account_id uuid NOT NULL REFERENCES account(id),
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);


CREATE TABLE users_audit (
    audit_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    audit_operation varchar(255) NOT NULL,
    audit_time timestamp NOT NULL,
    audit_user varchar(255) NOT NULL,
    id uuid NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    phone text NOT NULL,
    account_id uuid NOT NULL REFERENCES account(id),
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);


CREATE TRIGGER tr_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

CREATE TRIGGER tr_users_audit
    AFTER INSERT OR UPDATE OR DELETE ON users
    FOR EACH ROW
    EXECUTE PROCEDURE audit_trigger();


-- +migrate Down
DROP TRIGGER IF EXISTS tr_users_updated_at on users;
DROP TABLE IF EXISTS users;

DROP TRIGGER IF EXISTS tr_users_audit_updated_at on users;
DROP TABLE IF EXISTS users_audit;