-- +migrate Up

-- +migrate StatementBegin

CREATE OR REPLACE FUNCTION audit_trigger()
    RETURNS TRIGGER
    AS $func$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            EXECUTE 'INSERT INTO ' || quote_ident(TG_TABLE_SCHEMA) || '.' || quote_ident(TG_TABLE_NAME || '_audit') || ' SELECT uuid_generate_v4(), ''' || TG_OP || ''', now(), user, $1.*' USING OLD;
        ELSE
            EXECUTE 'INSERT INTO ' || quote_ident(TG_TABLE_SCHEMA) || '.' || quote_ident(TG_TABLE_NAME || '_audit') || ' SELECT uuid_generate_v4(), ''' || TG_OP || ''', now(), user, $1.*' USING NEW;
        END IF;
        RETURN NULL;
    END;
    $func$ LANGUAGE plpgsql;

-- +migrate StatementEnd

-- +migrate Down

DROP FUNCTION IF EXISTS audit_trigger();
