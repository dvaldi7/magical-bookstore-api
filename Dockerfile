FROM php:8.3-apache

# Argumentos
ARG TIMEZONE="Europe/Madrid"
ARG USER_ID=1000
ARG GROUP_ID=1000

# Set working directory
WORKDIR /var/www

# Copiar proyecto
COPY . /var/www/

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone

# Crear usuario para evitar problemas de permisos
RUN addgroup --gid ${GROUP_ID} appgroup \
    && adduser --disabled-password --gecos '' --uid ${USER_ID} --gid ${GROUP_ID} appuser

# Instalar dependencias de sistema
RUN apt update && apt install -y \
    libicu-dev git unzip zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev libwebp-dev \
    && rm -rf /var/lib/apt/lists/*

# Extensiones PHP necesarias
RUN docker-php-ext-install pdo_mysql pdo_pgsql intl gd \
    && docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Configurar Apache (opcional, si tienes tus configs)
COPY Application/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY Application/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Cambiar permisos
RUN chown -R appuser:appgroup /var/www

USER appuser

# Exponer puerto que Render espera
EXPOSE 10000

# Comando para arrancar Laravel en runtime (sin migraciones)
CMD php artisan serve --host 0.0.0.0 --port 10000
