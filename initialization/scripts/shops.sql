CREATE DATABASE shops;

-- connect to database
\c shops

CREATE TABLE IF NOT EXISTS shopify_access (
    access_id SERIAL PRIMARY KEY,
    shop_name VARCHAR(255) NOT NULL,
    access_token VARCHAR(255) NOT NULL,
    product_loaded BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT unique_shop_name UNIQUE (shop_name)
);
