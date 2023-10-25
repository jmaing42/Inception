FROM alpine:3.17

ARG INTRA_LOGIN
ENV INTRA_LOGIN $INTRA_LOGIN

COPY template.conf /root/template.conf

RUN \
    apk update \
    && apk add --no-cache nginx openssl dumb-init \
    && openssl req -x509 -nodes -days 1825 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -keyout /root/root-ca.key -out /root/root-ca.crt -subj "/C=KR/ST=SEOUL/L=GANGNAM/O=42seoul/OU=student/CN=${INTRA_LOGIN}" \
    && sed "s/\[\[INTRA_LOGIN\]\]/$INTRA_LOGIN/g" /root/template.conf > /root/app.conf

EXPOSE 443

ENTRYPOINT ["dumb-init", "--", "nginx", "-g", "daemon off;", "-c", "/root/app.conf"]
