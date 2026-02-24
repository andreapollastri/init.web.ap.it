#!/bin/bash

# curl https://init.web.ap.it/go.sh > go.sh && sh go.sh

PHP_VERSION_ATTR=php84
PHP_VERSION=8.4
MYSQL_VERSION_ATTR=latest
MYSQL_VERSION=8
FILAMENT_VERSION=5.0
LARAVEL_VERSION=12
DOMAIN=127001.it
ENDPOINT=https://init.web.ap.it

# Set the minimum stability for Composer installations
# (stable, beta, dev, etc...)
COMPOSER_MINIMUM_STABILITY=stable

TOTAL_STEPS=22
CURRENT_STEP=0

save_cursor() {
    printf "\033[s"
}

restore_cursor() {
    printf "\033[u"
}

move_cursor() {
    printf "\033[%d;%dH" "$1" "$2"
}

clear_line() {
    printf "\033[K"
}

show_progress() {
    local step_name="$1"
    ((CURRENT_STEP++))
    local percentage=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    local bar_length=50
    local filled_length=$((percentage * bar_length / 100))
    
    local bar=""
    for ((i=1; i<=filled_length; i++)); do bar+="█"; done
    for ((i=filled_length+1; i<=bar_length; i++)); do bar+="░"; done
    
    printf "\033[2J\033[H"
    
    local step_prefix="Step [$CURRENT_STEP/$TOTAL_STEPS]: "
    local truncated_step_name="$step_name"
    
    printf "\033[1;36m%s%s\033[0m\n" "$step_prefix" "$truncated_step_name"
    echo ""
    printf "\033[1;32m%s\033[0m \033[1;37m%3d%%\033[0m\n" "$bar" "$percentage"
    echo ""
}

clear

echo "\n"
echo "\033[0m  \033[1;33m🚀 \033[1;36mInitializer for Laravel and Filament\033[0m"
echo "\n"
echo "\033[0m  \033[1;32m✨ This script will set up a new Laravel project, including Filament,\033[0m"
echo "\033[0m     \033[1;32messential packages, and a preconfigured Laravel Sail environment,\033[0m"
echo "\033[0m     \033[1;32mallowing you to start developing your application with ease.\033[0m"
echo "\n"
echo "\033[0m  \033[1;34m🤟 It comes with a secure subdomain based on 127001.it service\033[0m"
echo "\033[0m     \033[1;34mand with convenient scripts to manage your development environment.\033[0m"
echo "\n"

if [ -t 1 ]; then
    read -n 1 -s -r -p "Press any key to continue..."
fi

clear

########################### STEP #################################
show_progress "Checking system requirements"

if ! docker info > /dev/null 2>&1; then
    echo "🛑 Docker is not running!" >&2;
    exit 1;
fi





########################### STEP #################################
show_progress "Subdomain Configuration"

SUBDOMAIN_PATH=$(basename "$(dirname "$(pwd)/go.sh")" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-')
read -p "❓ Choose desidered *.$DOMAIN subdomain (default $SUBDOMAIN_PATH): " SUBDOMAIN
SUBDOMAIN=${SUBDOMAIN:-$SUBDOMAIN_PATH}
HOST="$SUBDOMAIN.$DOMAIN"





########################### STEP #################################
show_progress "Creating helper scripts"

mkdir bin
curl -s $ENDPOINT/stubs/bin/bash.sh > bin/bash.sh
curl -s $ENDPOINT/stubs/bin/fresh.sh > bin/fresh.sh
curl -s $ENDPOINT/stubs/bin/pint.sh > bin/pint.sh
curl -s $ENDPOINT/stubs/bin/setup.sh > bin/setup.sh
curl -s $ENDPOINT/stubs/bin/start.sh > bin/start.sh
curl -s $ENDPOINT/stubs/bin/stop.sh > bin/stop.sh
curl -s $ENDPOINT/stubs/bin/cache.sh > bin/cache.sh
curl -s $ENDPOINT/stubs/bin/jobs.sh > bin/jobs.sh
curl -s $ENDPOINT/stubs/bin/test.sh > bin/test.sh
curl -s $ENDPOINT/stubs/bin/stan.sh > bin/stan.sh
sed -i '' "s/PHPV/$PHP_VERSION_ATTR/" bin/setup.sh





########################### STEP #################################
show_progress "Creating Laravel project"

docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "$(pwd):/var/www/html" \
    -w /var/www/html \
    laravelsail/$PHP_VERSION_ATTR-composer:latest \
    composer create-project laravel/laravel cache

mv cache/.* .
mv cache/* .

rm -rf cache





########################### STEP #################################
show_progress "Configuring project structure"

awk '/"name": "laravel\/laravel",/ {print; print "    \"version\": \"LARAVELV\","; next}1' composer.json > composer_temp.json
unlink composer.json
mv composer_temp.json composer.json

sed -i '' "s/LARAVELV/$LARAVEL_VERSION/" composer.json

./vendor/bin/sail bash -c "composer config minimum-stability $COMPOSER_MINIMUM_STABILITY"





########################### STEP #################################
show_progress "Installing Laravel Sail"

docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "$(pwd):/var/www/html" \
    -w /var/www/html \
    laravelsail/$PHP_VERSION_ATTR-composer:latest \
    composer require laravel/sail --dev





########################### STEP #################################
show_progress "Updating composer dependencies"

docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "$(pwd):/var/www/html" \
    -w /var/www/html \
    laravelsail/$PHP_VERSION_ATTR-composer:latest \
    composer update





########################### STEP #################################
show_progress "Setting up database and environment"

unlink database/migrations/0001_01_01_000000_create_users_table.php
curl -s $ENDPOINT/stubs/database/migrations/0001_01_01_000000_create_users_table.txt > database/migrations/0001_01_01_000000_create_users_table.php

unlink database/database.sqlite
unlink .env
unlink .env.example

curl -s $ENDPOINT/stubs/env.txt > .env.example





########################### STEP #################################
show_progress "Checking available ports"

curl -s $ENDPOINT/bin/ports.sh > ports.sh
sed -i '' "s/hostname/$HOST/" ports.sh
chmod +x ports.sh
sh ports.sh
unlink ports.sh





########################### STEP #################################
show_progress "Configuring development environment"

mkdir .devcontainer
curl -s $ENDPOINT/stubs/.devcontainer/.devcontainer.json > .devcontainer/.devcontainer.json

curl -s $ENDPOINT/stubs/docker-compose.yml > docker-compose.yml
sed -i '' "s/PHPV/$PHP_VERSION/" docker-compose.yml
sed -i '' "s/MYSQLV/$MYSQL_VERSION_ATTR/" docker-compose.yml

curl -s $ENDPOINT/stubs/Caddyfile > Caddyfile

sed -i '' "s/localhost/$HOST/" Caddyfile
sed -i '' "s/projectname/$SUBDOMAIN/" .env.example





########################### STEP #################################
show_progress "Setting up GitHub workflows"

mkdir .github
mkdir .github/workflows
curl -s $ENDPOINT/stubs/.github/workflows/laravel.yml > .github/workflows/laravel.yml
sed -i '' "s/PHPV/$PHP_VERSION/" .github/workflows/laravel.yml
sed -i '' "s/MYSQLV/$MYSQL_VERSION/" .github/workflows/laravel.yml





########################### STEP #################################
show_progress "Copying example environment file"

cp .env.example .env





########################### STEP #################################
show_progress "Starting Docker containers"

./vendor/bin/sail up -d
./vendor/bin/sail bash -c "php artisan key:generate"
./vendor/bin/sail bash -c "php artisan storage:link"





########################### STEP #################################
show_progress "Initializing database"

echo "Waiting for MySQL..."
sleep 30

./vendor/bin/sail bash -c "php artisan migrate --seed"





########################### STEP #################################
show_progress "Installing Filament"

./vendor/bin/sail bash -c "composer require filament/filament:"^$FILAMENT_VERSION" -W"
./vendor/bin/sail bash -c "php artisan filament:install --no-interaction"

curl -s $ENDPOINT/stubs/app/Providers/AppServiceProvider.txt > app/Providers/AppServiceProvider.php
curl -s $ENDPOINT/stubs/app/Providers/FilamentServiceProvider.txt > app/Providers/FilamentServiceProvider.php
curl -s $ENDPOINT/stubs/bootstrap/providers.txt > bootstrap/providers.php





########################### STEP #################################
show_progress "Installing additional packages"

./vendor/bin/sail bash -c "composer require spatie/laravel-backup"
./vendor/bin/sail bash -c "php artisan vendor:publish --provider=\"Spatie\Backup\BackupServiceProvider\""
rm -rf lang

./vendor/bin/sail bash -c "composer require league/flysystem-aws-s3-v3"

./vendor/bin/sail bash -c "php artisan migrate:fresh --seed"





########################### STEP #################################
show_progress "Installing development tools"

./vendor/bin/sail bash -c "composer require --dev larastan/larastan"
echo '/phpstan.neon' >> .gitignore

./vendor/bin/sail bash -c "composer require -W --dev laravel-shift/blueprint"
echo '/draft.yaml' >> .gitignore
echo '/.blueprint' >> .gitignore





########################### STEP #################################
show_progress "Installing Boost"

./vendor/bin/sail bash -c "composer require --dev laravel/boost"
./vendor/bin/sail bash -c "php artisan filament:install --no-interaction"






########################### STEP #################################
show_progress "Setting up project files"

unlink README.md
curl -s $ENDPOINT/stubs/README.md > README.md

curl -s $ENDPOINT/stubs/phpstan.neon.dist > phpstan.neon.dist
cp phpstan.neon.dist phpstan.neon

unlink app/Models/User.php
curl -s $ENDPOINT/stubs/app/Models/User.txt > app/Models/User.php

unlink resources/views/welcome.blade.php
curl -s $ENDPOINT/stubs/resources/views/welcome.blade.txt > resources/views/welcome.blade.php

./vendor/bin/sail bash -c "./vendor/bin/pint"

export $(grep -v '^#' .env | xargs)

url_line="$APP_URL (HTTP AVAILABLE ON PORT: $APP_PORT)"
panel_line="$APP_URL/panel (test@example.com / password)"
mailpit_line="http://$HOST:$FORWARD_MAILPIT_DASHBOARD_PORT"
minio_line="http://$HOST:$FORWARD_MINIO_CONSOLE_PORT"
mysql_line="mysql://$DB_USERNAME:$DB_PASSWORD@$HOST:$FORWARD_DB_PORT/$DB_DATABASE"
redis_line="redis://default@$HOST:$FORWARD_REDIS_PORT"

sed -i '' "s|initUrl|$APP_URL|" README.md
sed -i '' "s|initHost|$HOST|" README.md
sed -i '' "s|initMailpit|$mailpit_line|" README.md
sed -i '' "s|initMinio|$minio_line|" README.md
sed -i '' "s|initMysql|$mysql_line|" README.md
sed -i '' "s|initRedis|$redis_line|" README.md

########################### STEP #################################
show_progress "Adjusting file permissions"

echo "🚧 Adjust Permissions\n"
if sudo -n true 2>/dev/null; then
    sudo chown -R "$USER:" .
else
    echo "Please provide your computer password so we can make some final adjustments to your application's permissions."
    echo ""
    sudo chown -R "$USER:" .
fi





########################### STEP #################################
show_progress "Configuring SSL certificates"

docker cp $(docker-compose ps -q caddy):/data/caddy/pki/authorities/local/root.crt .
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain root.crt
unlink root.crt





########################### STEP #################################
show_progress "Installation completed successfully!"

clear

echo "\n\033[1;32m🍺 Your project has been installed!\033[0m\n"
echo "\033[1;33m👾 PROJECT ENDPOINTS\033[0m"
echo ""

printf "\033[1;36mURL:\033[0m     \033[1;37m%s\033[0m\n" "$url_line"
printf "\033[1;36mPANEL:\033[0m   \033[1;37m%s\033[0m\n" "$panel_line"
printf "\033[1;36mMAILPIT:\033[0m \033[1;37m%s\033[0m\n" "$mailpit_line"
printf "\033[1;36mMINIO:\033[0m   \033[1;37m%s\033[0m\n" "$minio_line"
printf "\033[1;36mMYSQL:\033[0m   \033[1;37m%s\033[0m\n" "$mysql_line"
printf "\033[1;36mREDIS:\033[0m   \033[1;37m%s\033[0m\n" "$redis_line"
echo ""

unlink go.sh
