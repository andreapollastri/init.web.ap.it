#!/bin/bash

./vendor/bin/sail bash -c "php artisan queue:work"
