#!/bin/bash

set -e

PSQL_SHORT()
{
    psql --dbname "$POSTGRES_DB" --username "$POSTGRES_USER" "$@";
}

connect_to_db()
{
    echo "Connection to db $1";
    psql --dbname "$1" --username "$POSTGRES_USER" -tc "$2";
}

create_database_if_not_exist()
{
    database_to_create="$1";
    additional_table_definition="$2";
    PSQL_SHORT -tc "SELECT 1 FROM pg_database WHERE datname = $database_to_create" \
        | grep -q 1 || PSQL_SHORT -c "CREATE DATABASE $database_to_create";
     
    connect_to_db "$database_to_create" "$additional_table_definition";
}

create_user_if_not_exist()
{
    user_to_create="$1";
    user_password="$2";
    granted_db="$3";
    PSQL_SHORT -tc "SELECT 1 FROM pg_user WHERE usename = '$user_to_create'" \
        | grep -q 1 \
        || PSQL_SHORT -c "CREATE USER $user_to_create WITH PASSWORD '$user_password';
            GRANT ALL PRIVILEGES ON DATABASE $granted_db TO $user_to_create;"
}

create_database_if_not_exist "conversation" "
    CREATE TABLE IF NOT EXISTS chat_line (
        line_text TEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        chat_id INTEGER PRIMARY KEY
    );";
create_database_if_not_exist "shops" "
    CREATE TABLE shopify_link (
        access_token VARCHAR(255) NOT NULL,
        shop_id INTEGER PRIMARY KEY
    );";

create_user_if_not_exist "wingman_service" "$WINGMAN_SERVICE_PASSWORD" "conversation";
create_user_if_not_exist "shopify_installer_service" "$SHOPIFY_INSTALLER_SERVICE_PASSWORD" "shops";
