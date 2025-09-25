#!/bin/bash

START_PORT=1024
END_PORT=65535

is_port_free() {
    local port=$1
    if ! lsof -i:$port -sTCP:LISTEN -t >/dev/null; then
        echo $port
    else
        echo ""
    fi
}

find_available_port() {
    local start_port=$1
    local end_port=$2
    for port in $(seq $start_port $end_port); do
        if [ -n "$(is_port_free $port)" ]; then
            echo $port
            return
        fi
    done
}

SSL_PORT=$(find_available_port $START_PORT $((START_PORT + 1000)))
APP_PORT=$(find_available_port $((START_PORT + 1001)) $((START_PORT + 2000)))
FORWARD_DB_PORT=$(find_available_port $((START_PORT + 2001)) $((START_PORT + 3000)))
FORWARD_REDIS_PORT=$(find_available_port $((START_PORT + 3001)) $((START_PORT + 4000)))
FORWARD_MAILPIT_PORT=$(find_available_port $((START_PORT + 4001)) $((START_PORT + 5000)))
FORWARD_MAILPIT_DASHBOARD_PORT=$(find_available_port $((START_PORT + 5001)) $((START_PORT + 6000)))
VITE_PORT=$(find_available_port $((START_PORT + 6001)) $((START_PORT + 7000)))
FORWARD_MINIO_PORT=$(find_available_port $((START_PORT + 7001)) $((START_PORT + 8000)))
FORWARD_MINIO_CONSOLE_PORT=$(find_available_port $((START_PORT + 8001)) $((START_PORT + 9000)))

sed -i '' "s/^SSL_PORT=.*/SSL_PORT=$SSL_PORT/" .env.example
sed -i '' "s/^APP_PORT=.*/APP_PORT=$APP_PORT/" .env.example
sed -i '' "s/^FORWARD_DB_PORT=.*/FORWARD_DB_PORT=$FORWARD_DB_PORT/" .env.example
sed -i '' "s/^FORWARD_REDIS_PORT=.*/FORWARD_REDIS_PORT=$FORWARD_REDIS_PORT/" .env.example
sed -i '' "s/^FORWARD_MAILPIT_PORT=.*/FORWARD_MAILPIT_PORT=$FORWARD_MAILPIT_PORT/" .env.example
sed -i '' "s/^FORWARD_MAILPIT_DASHBOARD_PORT=.*/FORWARD_MAILPIT_DASHBOARD_PORT=$FORWARD_MAILPIT_DASHBOARD_PORT/" .env.example
sed -i '' "s/^VITE_PORT=.*/VITE_PORT=$VITE_PORT/" .env.example
sed -i '' "s/^FORWARD_MINIO_PORT=.*/FORWARD_MINIO_PORT=$FORWARD_MINIO_PORT/" .env.example
sed -i '' "s/^FORWARD_MINIO_CONSOLE_PORT=.*/FORWARD_MINIO_CONSOLE_PORT=$FORWARD_MINIO_CONSOLE_PORT/" .env.example
sed -i '' "s/http:\/\/localhost/https:\/\/hostname:$SSL_PORT/" .env.example