#!/bin/bash

function changeNginxEnvVars {
    if [ -z "$2" ]; then
            echo "Environment variable '$1' not set."
            return
    fi

    echo "Replacing {$1} for $2 on /etc/nginx/sites-available/default"

    sed -i "s/{$1}/$2/g" /etc/nginx/sites-available/default
}

for _curVar in `env | awk -F = '{print $1}'`;do
    # awk has split them by the equals sign
    # Pass the name and value to our function
    changeNginxEnvVars ${_curVar} ${!_curVar}
done

# start php-fpm and nginx
crond -l 2
php-fpm
exec nginx
