FROM php:8.3-cli

# Instalar dependencias del sistema necesarias
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libicu-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    zip \
    && docker-php-ext-install pdo_mysql intl gd

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Establecer directorio de trabajo
WORKDIR /app

# Copiar proyecto
COPY . .

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Generar cachés de Laravel (optimiza en producción)
RUN php artisan config:clear && php artisan route:clear && php artisan view:clear

# Exponer el puerto que Render usa (10000)
EXPOSE 10000

# Comando de arranque (Render necesita host 0.0.0.0 y puerto 10000)
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=10000
