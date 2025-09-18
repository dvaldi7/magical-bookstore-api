# Stage 0: Base PHP + Apache
FROM php:8.3-apache AS base

# Instalar extensiones necesarias y utilidades
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git curl libonig-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip \
    && a2enmod rewrite

# Configurar Apache para Laravel
RUN sed -ri -e 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf \
    && sed -i '/<Directory \/var\/www\/public>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf \
    && echo "DirectoryIndex index.php" >> /etc/apache2/mods-enabled/dir.conf

# Crear usuario para Laravel
RUN groupadd -r appgroup && useradd -r -g appgroup appuser \
    && mkdir -p /var/www && chown -R appuser:appgroup /var/www

WORKDIR /var/www

# Stage 1: Composer
FROM composer:2 AS composer
WORKDIR /var/www
COPY --from=base /var/www /var/www
COPY composer.json composer.lock* ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Stage 2: Final image
FROM base AS final
WORKDIR /var/www

# Copiar la aplicación y vendor desde el stage de composer
COPY --from=composer /var/www /var/www

# Ajustar permisos
RUN chown -R appuser:appgroup /var/www \
    && chmod -R 755 /var/www

# Cambiar a usuario no root
USER appuser

# Exponer el puerto de Render
EXPOSE 10000

# Comando por defecto
CMD ["apache2-foreground"]

