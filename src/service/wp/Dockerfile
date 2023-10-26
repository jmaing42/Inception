FROM alpine:3.17

COPY init.sh /root/init.sh
COPY app.conf /root/app.conf

RUN \
    apk update \
    && apk add --no-cache php81 php81-phar php81-iconv php81-mysqli php81-fpm dumb-init \
    && wget -O - https://getcomposer.org/installer | php81 \
    && wget -O /root/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && install -m 111 /root/wp-cli.phar /usr/local/bin/wp-cli.phar

EXPOSE 9000

ENTRYPOINT ["dumb-init", "--", "sh", "-c", "sh /root/init.sh && php-fpm81 -F -R -y /root/app.conf"]
