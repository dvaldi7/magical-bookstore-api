# Stage 1: Base de PHP con Apache
FROM php:8.3-apache

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

# Configurar el directorio de trabajo
WORKDIR /var/www

# Copiar todo el proyecto, incluyendo el directorio 'public'
COPY . /var/www

# Instalar Composer para gestionar dependencias
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Instalar las dependencias de Composer.
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Crear los directorios 'storage' y 'bootstrap/cache' si no existen
RUN mkdir -p /var/www/storage /var/www/bootstrap/cache

# Ajustar permisos para que Apache pueda leer los archivos y la app pueda escribir en 'storage'
RUN chown -R www-data:www-data /var/www \
    && find /var/www -type f -exec chmod 644 {} \; \
    && find /var/www -type d -exec chmod 755 {} \; \
    && chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Exponer el puerto
EXPOSE 80

# Iniciar Apache
CMD ["apache2-foreground"]