
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
)


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
)
-- +migrate Down
