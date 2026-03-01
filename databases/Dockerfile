FROM mysql:8.0

# Basic MySQL configuration for the shopping-cart schema
# NOTE: These credentials are for local/dev use. Change them for production!
ENV MYSQL_ROOT_PASSWORD=rootpassword \
    MYSQL_DATABASE=shopping-cart \
    MYSQL_USER=appuser \
    MYSQL_PASSWORD=apppassword

# Copy the schema & table definitions so they are executed on first container startup
COPY mysql_query.sql /docker-entrypoint-initdb.d/01_mysql_query.sql

EXPOSE 3306

# Use the default MySQL entrypoint / command
