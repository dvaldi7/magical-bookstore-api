#!/bin/bash
set -e

# Reemplaza ${PORT} en nginx.conf
envsubst '${PORT}' < /etc/nginx/sites-available/default > /etc/nginx/sites-available/default.tmp
mv /etc/nginx/sites-available/default.tmp /etc/nginx/sites-available/default

# Arranca supervisord
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
