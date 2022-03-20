
-- +migrate Up
CREATE TABLE hall (
    id SERIAL UNIQUE PRIMARY KEY,
    cinema_id int NOT NULL REFERENCES cinema(id),
    name text NOT NULL,
    num_seats smallint NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);


CREATE TRIGGER tr_hall_updated_at
    BEFORE UPDATE ON hall
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

-- +migrate Down
DROP TRIGGER IF EXISTS tr_hall_updated_at on hall;
DROP TABLE IF EXISTS hall;