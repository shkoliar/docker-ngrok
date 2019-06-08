#!/bin/sh -e

CMD="ngrok"

PARAMS=${PARAMS:-$(echo $@)}

if [[ -n "$PARAMS" ]]; then
    CMD="$CMD $PARAMS"
else
    PROTOCOL=${PROTOCOL:-http}
    PORT=${PORT:-80}

    CMD="$CMD $PROTOCOL"

    if [[ -n "$REGION" ]]; then
        CMD="$CMD -region=$REGION"
    fi

    if [[ -n "$HOST_HEADER" ]]; then
        CMD="$CMD -host-header=$HOST_HEADER"
    fi

    if [[ -n "$BIND_TLS" ]]; then
        CMD="$CMD -bind-tls=$BIND_TLS"
    fi

    if [[ -n "$DEBUG" ]]; then
        CMD="$CMD -log stdout"
    fi

    if [[ -n "$DOMAIN" ]]; then
        CMD="$CMD $DOMAIN:$PORT"
    else
        CMD="$CMD $PORT"
    fi
fi

set -x
exec $CMD