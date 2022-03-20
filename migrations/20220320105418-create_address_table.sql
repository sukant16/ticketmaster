
-- +migrate Up
CREATE TABLE user_address (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL REFERENCES users(id),
    street_address text NOT NULL,
    city text NOT NULL,
    state text NOT NULL,
    country text NOT NULL,
    zip text NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TABLE user_address_audit (
    audit_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    audit_operation varchar(255) NOT NULL,
    audit_time timestamp NOT NULL,
    audit_user varchar(255) NOT NULL,
    id uuid,
    user_id uuid NOT NULL REFERENCES users(id),
    street_address text NOT NULL,
    city text NOT NULL,
    state text NOT NULL,
    country text NOT NULL,
    zip text NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);


CREATE TRIGGER tr_user_address_updated_at
    BEFORE UPDATE ON user_address
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

CREATE TRIGGER tr_user_address_audit
    AFTER INSERT OR UPDATE OR DELETE ON user_address
    FOR EACH ROW
    EXECUTE PROCEDURE audit_trigger();


-- +migrate Down
DROP TRIGGER IF EXISTS tr_user_address_updated_at on user_address;
DROP TABLE IF EXISTS user_address;

DROP TRIGGER IF EXISTS tr_user_address_audit_updated_at on user_address;
DROP TABLE IF EXISTS user_address_audit;

