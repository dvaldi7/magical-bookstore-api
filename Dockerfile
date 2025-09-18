# Use a base image with PHP and FPM, as we'll use Nginx to serve the site
FROM php:8.3-fpm

# Install necessary system packages
RUN apt-get update && apt-get install -y \
    nginx git curl libzip-dev zip unzip \
    && docker-php-ext-install pdo pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Copy your project files into the container
COPY . /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Create necessary directories and set permissions
RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/sites-available/default

# Expose port 80
EXPOSE 80

# Define the command to run when the container starts
# This command will start both PHP-FPM and Nginx
CMD service php8.3-fpm start && nginx -g "daemon off;"