# Use the official PHP image with Apache as the base
FROM php:8.3-apache

# Set the working directory to the project's root inside the container
WORKDIR /var/www/html

# Install necessary system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git curl \
    && docker-php-ext-install pdo pdo_mysql \
    && a2enmod rewrite

# Copy all project files from your local directory to the container's Apache web root.
COPY . /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Composer dependencies.
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Create the 'storage' and 'bootstrap/cache' directories if they don't exist
RUN mkdir -p storage bootstrap/cache

# Adjust permissions for Apache to be able to read and write to the necessary directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html

# Configure Apache's DocumentRoot to point to Laravel's public directory.
# This ensures Apache serves the application from the correct entry point.
# It also enables .htaccess overrides for pretty URLs.
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf \
    && sed -i '/<Directory \/var\/www\/html\/public>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf \
    && echo "DirectoryIndex index.php" >> /etc/apache2/mods-enabled/dir.conf

# Expose port 80 to the outside world
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]