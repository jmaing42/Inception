FROM alpine:3.17

COPY template.sql /root/template.sql

RUN \
    apk update \
    && apk add --no-cache mariadb dumb-init \
    && mkdir -p /run/mysqld /app \
    && mariadb-install-db --datadir /app \
    && sed "s/\[\[MARIADB_DATABASE\]\]/$MARIADB_DATABASE/g" /root/template.sql > /root/tmp_1.sql \
    && sed "s/\[\[MARIADB_USER\]\]/$MARIADB_USER/g" /root/tmp_1.sql > /root/tmp_2.sql \
    && sed "s/\[\[MARIADB_PASSWORD\]\]/$MARIADB_PASSWORD/g" /root/tmp_2.sql > /root/app.sql

EXPOSE 3306

ENTRYPOINT ["dumb-init", "--", "mariadbd-safe", "--datadir", "/app", "--user", "root", "--init-file", "/root/app.sql"]
