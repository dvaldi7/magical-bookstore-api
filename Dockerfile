# ========================
# Dockerfile para Laravel
# ========================

# Imagen base con PHP y Apache
FROM php:8.3-apache

# Variables de entorno
ENV APACHE_DOCUMENT_ROOT /var/www/public

# Instalar extensiones de PHP necesarias
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    curl \
    libonig-dev \
    && docker-php-ext-install pdo_mysql mbstring zip \
    && a2enmod rewrite

# Configurar Apache para Laravel
RUN sed -ri -e 's!/var/www/html!/var/www/public!g' /etc/apache2/sites-available/000-default.conf \
    && sed -i '/<Directory \/var\/www\/public>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf \
    && echo "DirectoryIndex index.php" >> /etc/apache2/mods-enabled/dir.conf

# Crear usuario appuser
RUN groupadd -r appgroup && useradd -r -g appgroup appuser \
    && chown -R appuser:appgroup /var/www

# Copiar la aplicación
COPY . /var/www

# Cambiar permisos
RUN chown -R appuser:appgroup /var/www \
    && chmod -R 755 /var/www

# Instalar Composer y dependencias
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
USER appuser
RUN composer install --no-dev --optimize-autoloader

# Volver al usuario root para Apache
USER root

# Exponer puerto que Render usa
EXPOSE 10000

# Comando de inicio
CMD ["apache2-foreground"]
