
-- +migrate Up
CREATE TABLE IF NOT EXISTS shows (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_on DATE NOT NULL,
    start_time timestamp NOT NULL,
    end_time timestamp NOT NULL,
    movie_id uuid NOT NULL FOREIGN KEY REFERENCES movies(id),
    cinema_hall_id uuid NOT NULL FOREIGN KEY REFERENCES cinema_halls(id),
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);


CREATE TRIGGER tr_shows_updated_at
    BEFORE UPDATE ON shows
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

-- +migrate Down

DROP TRIGGER IF EXISTS tr_shows_updated_at on shows;

DROP TABLE IF EXISTS shows;