#!/bin/bash

if ! docker info > /dev/null 2>&1; then
    echo "🛑 Docker is not running!" >&2;
    exit 1;
fi

clear

echo "🚀 Project Setup\n"

clear

cp .env.example .env

docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "$(pwd):/var/www/html" \
    -w /var/www/html \
    laravelsail/PHPV-composer:latest \
    composer install --ignore-platform-reqs

./vendor/bin/sail up -d

./vendor/bin/sail bash -c "php artisan key:generate"

./vendor/bin/sail bash -c "php artisan storage:link"

echo "Waiting for MySQL..."
sleep 30

./vendor/bin/sail bash -c "php artisan migrate --seed"

cp phpstan.neon.dist phpstan.neon

clear

echo "🚧 Adjust Permissions\n"
if sudo -n true 2>/dev/null; then
    sudo chown -R "$USER:" .
else
    echo "Please provide your computer password so we can make some final adjustments to your application's permissions."
    echo ""
    sudo chown -R "$USER:" .
fi

docker cp $(docker compose ps -q caddy):/data/caddy/pki/authorities/local/root.crt .   
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain root.crt
unlink root.crt

clear

echo "🍺 Your project has been installed!\n"
