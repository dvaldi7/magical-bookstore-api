FROM php:8.3-apache

# Argumentos
ARG TIMEZONE="Europe/Madrid"
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG SYSTEM_USER="appuser"
ARG SYSTEM_GROUP="appgroup"

# Set working directory
WORKDIR /var/www

# Copiar proyecto
COPY . /var/www/

# Set timezone
RUN ln -snf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo ${TIMEZONE} > /etc/timezone \
    && printf '[PHP]\ndate.timezone = "%s"\n' ${TIMEZONE} > /usr/local/etc/php/conf.d/tzone.ini

# Crear usuario y grupo para evitar problemas de permisos
RUN addgroup --gid ${GROUP_ID} ${SYSTEM_GROUP} \
    && adduser --disabled-password --gecos '' --uid ${USER_ID} --gid ${GROUP_ID} ${SYSTEM_USER}

# Instalar dependencias de sistema
RUN apt update && apt install -y \
    libicu-dev git unzip zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev libwebp-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Extensiones PHP necesarias
RUN docker-php-ext-install pdo_mysql pdo_pgsql intl gd \
    && docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Habilitar mod_rewrite (necesario para Laravel)
RUN a2enmod rewrite

# Copiar config de Apache
COPY Application/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY Application/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Cambiar permisos
RUN chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} /var/www

USER ${USER_ID}

# Exponer puerto que Render espera
EXPOSE 10000

# Apache será el que ejecute Laravel
CMD ["apache2-foreground"]
