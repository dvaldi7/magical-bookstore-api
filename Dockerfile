# Stage 1: Base de PHP con Apache
FROM php:8.3-apache AS base

# Habilitar módulos necesarios
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git curl \
    && docker-php-ext-install pdo pdo_mysql \
    && a2enmod rewrite

# Cambiar DocumentRoot a /var/www/public
RUN sed -ri -e 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf \
    && sed -i '/<Directory \/var\/www\/public>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf \
    && echo "DirectoryIndex index.php" >> /etc/apache2/mods-enabled/dir.conf

# Crear usuario para seguridad
RUN groupadd -r appgroup && useradd -r -g appgroup appuser \
    && mkdir -p /var/www && chown -R appuser:appgroup /var/www

WORKDIR /var/www

# Copiar todo el proyecto. Esta es la clave para solucionar el problema.
COPY . /var/www

# Instalar dependencias de Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Ajustar permisos
RUN chown -R appuser:appgroup /var/www \
    && chmod -R 755 /var/www

# Cambiar al usuario no root
USER appuser

# Exponer puerto 80
EXPOSE 80

# Iniciar Apache en primer plano
CMD ["apache2-foreground"]