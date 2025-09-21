# Usa PHP 8.3 con FPM
FROM php:8.3-fpm

# Instala paquetes necesarios
RUN apt-get update && apt-get install -y \
    nginx git curl libzip-dev zip unzip supervisor \
    && docker-php-ext-install pdo pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Copia el proyecto completo
COPY . /var/www/html

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Prepara directorios y permisos
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Verifica que index.php existe en public/
RUN test -f /var/www/html/public/index.php || (echo "❌ ERROR: public/index.php no existe" && exit 1)

# Configuración de Nginx
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Configuración de Supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Render asigna el puerto en la variable de entorno $PORT
EXPOSE ${PORT}

# Inicia Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
