# Base image for PHP development
FROM php:8.2-cli

# Install necessary development dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    curl \
    libzip-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    pkg-config \
    libssl-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    nodejs \
    npm

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install extensions
RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip mbstring pdo pdo_mysql curl gd

# Setup Xdebug for PHPStorm
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Install DevContainer CLI if needed
RUN npm install -g @devcontainers/cli

# Set the working directory
WORKDIR /workspace

# Expose the ports for Xdebug
EXPOSE 9003

# Add the default PHP.ini config file
COPY php.ini /usr/local/etc/php/conf.d/

# Command to keep the container running
CMD ["php", "-a"]
