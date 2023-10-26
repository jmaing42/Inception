#!/bin/sh

set -e

[ -d /app/wordpress ] || (rm -rf /root/wordpress && wp-cli.phar core download --path=/root/wordpress && mv /root/wordpress /app/wordpress)

[ -f /app/wordpress/wp-config.php ] || wp-cli.phar config create --dbhost=db --dbname=${MARIADB_DATABASE} --dbuser=${MARIADB_USER} --dbpass=${MARIADB_PASSWORD} --path=/app/wordpress
wp-cli.phar core install --url=${INTRA_LOGIN}.42.fr --title="${WORDPRESS_TITLE}" --admin_name="${WORDPRESS_USER}" --admin_password="${WORDPRESS_PASSWORD}" --admin_email=${WORDPRESS_EMAIL} --path=/app/wordpress --url="https://${INTRA_LOGIN}.42.fr/wordpress"
