FROM alpine:3.17

RUN \
    apk update \
    && apk add --no-cache nginx openssl \
    && openssl req -x509 -nodes -days 1825 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -keyout /etc/ssl/private/root-ca.key -out /etc/ssl/private/root-ca.crt -subj "/C=KR/ST=SEOUL/L=GANGNAM/O=42seoul/OU=student/CN=${INTRA_LOGIN}" \
    && echo "// TODO:" && exit 1
