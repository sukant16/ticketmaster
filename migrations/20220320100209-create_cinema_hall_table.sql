
-- +migrate Up

CREATE TABLE cinema (
    id SERIAL UNIQUE PRIMARY KEY,
    name text NOT NULL,
    num_cinema_halls smallint NOT NULL,
    street_address text NOT NULL,
    city text NOT NULL,
    state text NOT NULL,
    country text NOT NULL,
    zip text NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);


CREATE TABLE cinema_audit (
    audit_id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    audit_operation varchar(255) NOT NULL,
    audit_time timestamp NOT NULL,
    audit_user varchar(255) NOT NULL,
    id int,
    name text NOT NULL,
    num_cinema_halls smallint NOT NULL,
    street_address text NOT NULL,
    city text NOT NULL,
    state text NOT NULL,
    country text NOT NULL,
    zip text NOT NULL,
    start_time time NOT NULL,
    end_time time NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TRIGGER tr_cinema_updated_at
    BEFORE UPDATE ON cinema
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

CREATE TRIGGER tr_cinema_audit
    AFTER INSERT OR UPDATE OR DELETE ON cinema
    FOR EACH ROW
    EXECUTE PROCEDURE audit_trigger();


-- +migrate Down
DROP TRIGGER IF EXISTS tr_cinema_updated_at on cinema;
DROP TABLE IF EXISTS cinema;

DROP TRIGGER IF EXISTS tr_cinema_audit_updated_at on cinema;
DROP TABLE IF NOT EXISTS cinema_audit;
