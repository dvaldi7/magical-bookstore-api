#!/bin/bash
set -e

# Sustituimos el puerto dinámico de Render en el conf de Nginx
sed -i "s/listen 8080;/listen ${PORT};/" /etc/nginx/sites-available/default

# Arranca supervisord
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
