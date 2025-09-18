# Use the official PHP image with Apache as the base
FROM php:8.3-apache

# Install necessary system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git curl \
    && docker-php-ext-install pdo pdo_mysql \
    && a2enmod rewrite

# Copy all project files from your local directory to the container's Apache web root.
COPY . /var/www/html

# Set the working directory to the project's root inside the container
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Composer dependencies.
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Create the 'storage' and 'bootstrap/cache' directories if they don't exist
RUN mkdir -p storage bootstrap/cache

# Adjust permissions for Apache to be able to read and write to the necessary directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html

# Overwrite Apache's default site configuration to point to Laravel's public directory.
# This approach is more reliable than using sed or a new file.
RUN echo 'ServerName localhost' >> /etc/apache2/apache2.conf
RUN echo 'DocumentRoot /var/www/html/public' > /etc/apache2/sites-available/000-default.conf
RUN echo '<Directory /var/www/html/public>' >> /etc/apache2/sites-available/000-default.conf
RUN echo '    Options Indexes FollowSymLinks' >> /etc/apache2/sites-available/000-default.conf
RUN echo '    AllowOverride All' >> /etc/apache2/sites-available/000-default.conf
RUN echo '    Require all granted' >> /etc/apache2/sites-available/000-default.conf
RUN echo '</Directory>' >> /etc/apache2/sites-available/000-default.conf
RUN echo 'ErrorLog ${APACHE_LOG_DIR}/error.log' >> /etc/apache2/sites-available/000-default.conf
RUN echo 'CustomLog ${APACHE_LOG_DIR}/access.log combined' >> /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default.conf

# Expose port 80 to the outside world
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]