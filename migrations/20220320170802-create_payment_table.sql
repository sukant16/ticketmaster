
-- +migrate Up

CREATE TYPE payment_status as ENUM ('paid', 'unpaid', 'pending', 'declined', 'canceled', 'refunded', 'settled');

CREATE TABLE payment(
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    status payment_status NOT NULL,
    amount numeric NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);


CREATE TABLE payment_audit(
    audit_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    audit_operation varchar(255) NOT NULL,
    audit_time timestamp NOT NULL,
    audit_user varchar(255) NOT NULL,
    id uuid,
    status payment_status NOT NULL,
    amount numeric NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TRIGGER tr_payment_updated_at
    BEFORE UPDATE ON payment
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

CREATE TRIGGER tr_payment_audit
    AFTER INSERT OR UPDATE OR DELETE ON payment
    FOR EACH ROW
    EXECUTE PROCEDURE audit_trigger();


-- +migrate Down
DROP TRIGGER IF EXISTS tr_payment_updated_at on payment;
DROP TABLE IF EXISTS payment;

DROP TRIGGER IF EXISTS tr_payment_audit_updated_at on payment;
DROP TABLE IF EXISTS payment_audit;
DROP TYPE IF EXISTS payment_status;