FROM php:8.2-cli

# Install necessary PHP extensions
RUN apt-get update && apt-get install -y git unzip zip libzip-dev \
    && docker-php-ext-install zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create work directory
WORKDIR /var/www

# Install Node.js and npm for frontend work
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

# Install Xdebug for debugging in PhpStorm
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Expose ports for PhpStorm debugging
EXPOSE 9000

CMD [ "php", "-S", "0.0.0.0:2007", "-t", "/var/www" ]
