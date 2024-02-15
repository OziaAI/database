CREATE DATABASE shops;

-- connect to database
\c shops

CREATE TABLE IF NOT EXISTS shopify_access (
    id SERIAL PRIMARY KEY,
    shop_name VARCHAR(255) NOT NULL,
    access_token VARCHAR(255) NOT NULL,
    product_loaded BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT unique_shop_name UNIQUE (shop_name)
);

CREATE OR REPLACE FUNCTION notify_change()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM pg_notify('access_update', NEW.access_id::text);
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER shopify_access_after_insert
AFTER INSERT ON shopify_access
FOR EACH ROW
EXECUTE FUNCTION notify_change();
