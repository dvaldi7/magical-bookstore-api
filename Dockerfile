# Stage 1: Base de PHP con Apache
FROM php:8.3-apache

# Habilitar módulos de Apache y extensiones de PHP
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git curl \
    && docker-php-ext-install pdo pdo_mysql \
    && a2enmod rewrite

# Copiar todos los archivos del proyecto a la raíz de la app
COPY . /var/www/html

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar dependencias de Composer
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Crear directorios de 'storage' y 'cache' si no existen
RUN mkdir -p storage bootstrap/cache

# Ajustar los permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html

# Copiar el archivo de configuración de Apache y habilitarlo
COPY vhost.conf /etc/apache2/sites-available/000-default.conf

# Reiniciar Apache para que tome los cambios
RUN a2dissite 000-default.conf
RUN a2ensite 000-default.conf

# Exponer el puerto
EXPOSE 80

# Iniciar Apache en primer plano
CMD ["apache2-foreground"]