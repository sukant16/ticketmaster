
-- +migrate Up

CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'canceled');

CREATE TABLE booking (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    number_of_seats smallint NOT NULL,
    status booking_status NOT NULL, 
    show_id uuid NOT NULL REFERENCES show(id),
    payment_id uuid NOT NULL REFERENCES payment(id),
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);


CREATE TABLE booking_audit (
    audit_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    audit_operation varchar(255) NOT NULL,
    audit_user varchar(255) NOT NULL,
    audit_time timestamp NOT NULL,
    id uuid,
    number_of_seats smallint NOT NULL,
    status booking_status NOT NULL, 
    show_id uuid NOT NULL REFERENCES show(id),
    payment_id uuid NOT NULL REFERENCES payment(id),
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TRIGGER tr_booking_updated_at
    BEFORE UPDATE ON booking
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

CREATE TRIGGER tr_booking_audit
    AFTER INSERT OR UPDATE OR DELETE ON booking
    FOR EACH ROW
    EXECUTE PROCEDURE audit_trigger();


-- +migrate Down
DROP TRIGGER IF EXISTS tr_booking_updated_at on booking;
DROP TABLE IF EXISTS booking;


DROP TRIGGER IF EXISTS tr_booking_audit_updated_at on booking;
DROP TABLE IF EXISTS booking_audit;
DROP TYPE IF EXISTS booking_status;