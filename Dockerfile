FROM alpine as ngrok
ARG TARGETPLATFORM

RUN apk add --no-cache --virtual .bootstrap-deps ca-certificates

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=amd64; fi && \
    wget -O /tmp/ngrok.tgz "https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-${ARCHITECTURE}.tgz" && \
    tar -xvzf /tmp/ngrok.tgz 


RUN apk del .bootstrap-deps

RUN rm -rf /tmp/*

RUN rm -rf /var/cache/apk/*



FROM busybox:glibc

LABEL maintainer="Dmitry Shkoliar @shkoliar"

COPY --from=ngrok /ngrok /bin/ngrok
COPY start.sh /

RUN mkdir -p /home/ngrok /home/ngrok/.ngrok2 && \
    printf 'web_addr: 0.0.0.0:4551' > /home/ngrok/.ngrok2/ngrok.yml && \
    addgroup -g 4551 -S ngrok && \
    adduser -u 4551 -S ngrok -G ngrok -h /home/ngrok -s /bin/ash && \
    chown -R ngrok:ngrok /home/ngrok && \
    chmod +x /start.sh

USER ngrok:ngrok

EXPOSE 4551

ENTRYPOINT ["/start.sh"]