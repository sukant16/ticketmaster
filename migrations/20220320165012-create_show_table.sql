
-- +migrate Up
CREATE TABLE show (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_on DATE NOT NULL,
    start_time timestamp NOT NULL,
    end_time timestamp NOT NULL,
    movie_id uuid NOT NULL REFERENCES movies(id),
    hall_id uuid NOT NULL REFERENCES cinema_halls(id),
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TRIGGER tr_show_updated_at
    BEFORE UPDATE ON show
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

-- +migrate Down

DROP TRIGGER IF EXISTS tr_show_updated_at on show;
DROP TABLE IF EXISTS show;