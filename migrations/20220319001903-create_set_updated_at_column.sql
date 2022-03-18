-- +migrate Up

-- +migrate StatementBegin

CREATE OR REPLACE FUNCTION set_updated_at_column()
    RETURNS TRIGGER AS $$
    BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
    END;
    $$
    LANGUAGE plpgsql;

-- +migrate StatementEnd

-- +migrate Down
DROP FUNCTION set_updated_at_column();
