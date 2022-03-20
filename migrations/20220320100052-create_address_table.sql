
-- +migrate Up
CREATE TABLE IF NOT EXISTS addresses (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL FOREIGN KEY REFERENCES users(id),
    street_address text NOT NULL,
    city text NOT NULL,
    state text NOT NULL,
    zip text NOT NULL,
    created_at timestamp NOT NULL DEFAULT now(),
    updated_at timestamp NOT NULL DEFAULT now()
);

CREATE TRIGGER tr_addresses_updated_at
    BEFORE UPDATE ON addresses
    FOR EACH ROW EXECUTE PROCEDURE set_updated_at_column();

-- +migrate Down
DROP TRIGGER IF EXISTS tr_addresses_updated_at on addresses;
DROP TABLE IF EXISTS addresses;
