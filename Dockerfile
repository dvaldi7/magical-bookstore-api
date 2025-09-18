# Usa una imagen base con PHP y FPM
FROM php:8.3-fpm

# Instala los paquetes necesarios del sistema
RUN apt-get update && apt-get install -y \
    nginx git curl libzip-dev zip unzip \
    && docker-php-ext-install pdo pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Copia los archivos de tu proyecto al contenedor
COPY . /var/www/html

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instala las dependencias de Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Crea los directorios necesarios y establece los permisos
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Elimina el sitio predeterminado de Nginx y copia el tuyo
RUN rm /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Expone el puerto 80
EXPOSE 80

# Define el comando para iniciar el contenedor
# Esto inicia PHP-FPM y Nginx en primer plano
CMD ["/bin/sh", "-c", "service nginx start && php-fpm"]