# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set timezone environment variable and prevent interactive prompts
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Update package lists and install required system packages in steps
RUN apt-get update && apt-get install -y \
    software-properties-common \
    tzdata \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

# Add the PHP repository
RUN add-apt-repository ppa:ondrej/php \
    && apt-get update

# Install PHP 8.0 and its extensions
RUN apt-get install -y \
    php8.0 \
    php8.0-cli \
    php8.0-common \
    php8.0-xml \
    php8.0-mbstring \
    php8.0-curl \
    php8.0-zip \
    php8.0-mysql \
    php-pear \
    php-dev \
    && apt-get clean

# Install remaining system utilities
RUN apt-get install -y \
    openssh-server \
    git \
    curl \
    wget \
    zip \
    unzip \
    build-essential \
    && apt-get clean

# Set up SSH for PhpStorm remote access
RUN mkdir /var/run/sshd \
    && echo 'root:rootpassword' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Clone the GitHub repository (replace with your repository URL)
RUN git clone https://github.com/AspiredMC/Jetbrains-Workspace.git /app

# Set the working directory to the cloned repository
WORKDIR /app

# Install PHP dependencies using Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install

# Expose the SSH port (set via environment variable or fallback to 22)
EXPOSE ${SSH_PORT:-22}

# Create an entrypoint script to start SSH
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the default command to run when the container starts
CMD ["/entrypoint.sh"]
