#!/bin/sh

set -e

cd "$(dirname "$0")"

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
                            if [ -n "$EDITOR" ]; then
                                $EDITOR .env
                                while ! sh ./validate.sh; do
                                    printf "Invalid .env file. edit once more? [Y/n] > "
                                    while true; do
                                        read -r RESPONSE
                                        case "$RESPONSE" in
                                            [yY][eE][sS]|[yY]|"")
                                                $EDITOR .env
                                                break
                                                ;;
                                            [Nn][Oo]|[Nn])
                                                exit 1
                                                ;;
                                            *)
                                                printf "Response not recognized. Please enter one of y or n [Y/n] > "
                                                ;;
                                        esac
                                    done
                                done
                                cp .env ../srcs/.env
                                echo "Successfully written to .env file."
                                exit 0
                            else
                                echo "\$EDITOR is not set. Please set the \$EDITOR environment variable to your preferred text editor."
                                exit 1
                            fi
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
