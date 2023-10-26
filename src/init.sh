#!/bin/sh

set -e

cd "$(dirname "$0")"

input() {
    VARIABLE_NAME="$1"

    printf "$VARIABLE_NAME="
    if ! IFS= read -r VALUE; then
        echo "Failed to input VALUE."
        exit 1
    fi
    echo "${VARIABLE_NAME}=${VALUE}" >> .env
}

[ -f "../srcs/.env" ] || {
    printf ".env file not found. Would you like to copy the sample .env file? [y/N] > "
    while true; do
        read -r RESPONSE
        case "$RESPONSE" in
            [yY][eE][sS]|[yY])
                cp ../srcs/.env.sample ../srcs/.env
                echo ".env file copied."
                exit 0
                ;;
            [Nn][Oo]|[Nn]|"")
                echo "Write your own .env into the srcs directory to continue."
                printf "Would you like to edit the .env file? [Y/n] > "
                while true; do
                    read -r RESPONSE
                    case "$RESPONSE" in
                        [yY][eE][sS]|[yY]|"")
                            rm -f .env
                            echo "Enter .env content:"
                            input INTRA_LOGIN
                            input MARIADB_DATABASE
                            input MARIADB_USER
                            input MARIADB_PASSWORD
                            input WORDPRESS_TITLE
                            input WORDPRESS_USER
                            input WORDPRESS_PASSWORD
                            input WORDPRESS_EMAIL
                            cp .env ../srcs/.env
                            echo "Successfully written to .env file."
                            exit 0
                            ;;
                        [Nn][Oo]|[Nn])
                            exit 1
                            ;;
                        *)
                            printf "Response not recognized. Please enter one of y or n [Y/n] > "
                            ;;
                    esac
                done
                ;;
            *)
                printf "Response not recognized. Please enter one of y or n [y/N] > "
                ;;
        esac
    done
}
