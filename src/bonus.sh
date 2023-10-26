#!/bin/sh

set -e

cd "$(dirname "$0")"

if [ ! -f ../.intra_login.txt ]; then
    echo "Initialize first. read README.md"
    exit 1
fi

DATADIR="/home/$(cat ../.intra_login.txt)/data/wordpress"

cp ./static_website.html "$DATADIR/index.html"
echo "<?php phpinfo(); ?>" > "$DATADIR/phpinfo.php"

DOWNLOAD_PATH="$DATADIR/adminer.php"
DOWNLOAD_URL="https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-mysql.php"

if command -v wget &> /dev/null; then
    wget -O "$DOWNLOAD_PATH" "$DOWNLOAD_URL"
elif command -v curl &> /dev/null; then
    curl -Lo "$DOWNLOAD_PATH" "$DOWNLOAD_URL"
else
    echo "Neither wget nor curl is available in your environment."
    exit 1
fi
