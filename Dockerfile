FROM    alpine as ngrok

RUN     apk add --no-cache --virtual .bootstrap-deps ca-certificates && \
        wget -O /tmp/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && \
        unzip -o /tmp/ngrok.zip -d / && \
        apk del .bootstrap-deps && \
        rm -rf /tmp/* && \
        rm -rf /var/cache/apk/*

FROM    busybox:glibc

LABEL   maintainer="Dmitry Shkoliar @shkoliar"

COPY    --from=ngrok /ngrok /bin/ngrok
COPY    start.sh /
        
RUN     mkdir -p /home/ngrok /home/ngrok/.ngrok2 && \
		printf 'web_addr: 0.0.0.0:4551' > /home/ngrok/.ngrok2/ngrok.yml && \
		addgroup -g 4551 -S ngrok && \
        adduser -u 4551 -S ngrok -G ngrok -h /home/ngrok -s /bin/ash && \
		chown -R ngrok:ngrok /home/ngrok && \
        chmod +x /start.sh

USER    ngrok:ngrok

EXPOSE  4551

CMD     /start.sh