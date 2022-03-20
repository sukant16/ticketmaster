-- +migrate Up

CREATE TABLE movies (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    title text NOT NULL,
    description text,
    duration smallint NOT NULL,
    language text NOT NULL,
    release_date DATE  NOT NULL,
    country text NOT NULL,
    genre text NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);


CREATE TRIGGER tr_movies_updated_at
    BEFORE UPDATE ON movies
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

-- +migrate Down

DROP TRIGGER IF EXISTS tr_movies_updated_at on movies;

DROP TABLE IF EXISTS movies;