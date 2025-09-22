#!/bin/bash
set -e

# Sustituir la variable ${PORT} en la config de nginx por el valor real
sed -i "s/\${PORT}/${PORT}/g" /etc/nginx/sites-available/default

# Iniciar supervisord (que a su vez arranca nginx y php-fpm)
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
