#!/bin/sh

if [ ! -f .env ]; then
    echo ".env file not found."
    exit 1
fi

validate_format() {
    while IFS= read -r LINE; do
        MATCH=$(echo "$LINE" | cut -c 1)
        if [ "$MATCH" = "#" ] || [ "$LINE" = "" ]; then
            continue
        fi
        MATCH=$(echo "$LINE" | grep -E "^[A-Za-z0-9_]+=.*$")
        if [ "$MATCH" = "" ]; then
            echo "Failed to parse .env: ${LINE}"
            return 1
        fi
    done < .env
    return 0
}

validate_exists() {
    VARIABLE_NAME="$1"

    if [ "$(grep -Ec "^$VARIABLE_NAME=" < .env)" != "1" ]; then
        echo "Missing or duplicate variable: $VARIABLE_NAME";
        return 1
    else
        return 0
    fi
}

validate_port() {
    VARIABLE_NAME="$1"

    if ! validate_exists "$VARIABLE_NAME"; then
        return 1
    else
        if [ "$(grep -Ec "^$VARIABLE_NAME=([1-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$" < .env)" != "1" ]; then
            echo "$VARIABLE_NAME must be a valid port number";
            return 1
        fi
        return 0
    fi
}

FAIL=0
if ! validate_format; then
    FAIL=1
fi
if ! validate_exists INTRA_LOGIN; then
    FAIL=1
fi
if ! validate_port MARIADB_PORT; then
    FAIL=1
fi

exit $FAIL
