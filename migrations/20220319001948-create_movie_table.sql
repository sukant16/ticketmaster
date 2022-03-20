-- +migrate Up

CREATE TABLE movie (
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

CREATE TABLE movie_audit (
    audit_id uuid PRIMARY KEY,
    audit_operation varchar(255) NOT NULL,
    audit_time timestamp NOT NULL,
    audit_user varchar(255) NOT NULL,
    id uuid NOT NULL,
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


CREATE TRIGGER tr_movie_updated_at
    BEFORE UPDATE ON movie
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

CREATE TRIGGER tr_movie_audit
    AFTER INSERT OR UPDATE OR DELETE ON movie
    FOR EACH ROW
    EXECUTE PROCEDURE audit_trigger();

-- +migrate Down

DROP TRIGGER IF EXISTS tr_movie_updated_at on movie;
DROP TRIGGER IF EXISTS tr_movie_audit on movie;

DROP TABLE IF EXISTS movie;
DROP TABLE IF EXISTS movie_audit;