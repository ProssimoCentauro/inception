#!/bin/bash

WP_PATH=/var/www/html

wait_for_db() {
    local max_attempts=30
    local attempt=1
    echo "Waiting for MariaDB (max ${max_attempts}s)..."
    while [ $attempt -le $max_attempts ]; do
        if mysql -h mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; then
            echo "MariaDB is up!"
            return 0
        fi
        echo "Attempt $attempt/$max_attempts: MariaDB not ready yet..."
        sleep 1
        attempt=$((attempt + 1))
    done
    echo "Failed to connect to MariaDB after $max_attempts attempts."
    return 1
}

wait_for_db || exit 1

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Downloading WordPress..."
    wp core download --path="$WP_PATH" --allow-root
    echo "Creating wp-config.php..."
    wp config create --path="$WP_PATH" --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" --dbhost="mariadb" --allow-root
    echo "Installing WordPress..."
    wp core install --path="$WP_PATH" --url="$DOMAIN_NAME" --title="Inception" \
        --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" --allow-root
    echo "Creating additional user..."
    wp user create "$WP_USER" "$WP_USER_EMAIL" --path="$WP_PATH" --role=subscriber \
        --user_pass="$WP_USER_PASSWORD" --allow-root
else
    echo "WordPress already configured."
fi

chown -R www-data:www-data "$WP_PATH"

wp plugin install redis-cache --activate --allow-root --path=/var/www/html
wp config set WP_REDIS_HOST redis --allow-root --path=/var/www/html
wp redis enable --allow-root --path=/var/www/html

exec php-fpm8.2 -F
