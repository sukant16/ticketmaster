
-- +migrate Up
CREATE TYPE  seat_status  AS ENUM ('available', 'reserved', 'unavailable');
CREATE TYPE  seat_category  as ENUM ('regular', 'premium');

CREATE TABLE seat (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    hall_id int NOT NULL REFERENCES hall(id),
    row smallint NOT NULL,
    col smallint NOT NULL,
    status seat_status NOT NULL,
    category seat_category NOT NULL,
    price numeric NOT NULL, 
    booking_id uuid NOT NULL REFERENCES booking(id),
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TRIGGER tr_seat_updated_at
    BEFORE UPDATE ON seat
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();


-- +migrate Down
DROP TRIGGER IF EXISTS tr_seat_updated_at on seat;
DROP TABLE IF EXISTS seat;
DROP TYPE IF EXISTS seat_status;
DROP TYPE IF EXISTS seat_category;