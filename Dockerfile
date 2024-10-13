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
    npm \
    openssh-server

# Enable SSH for remote connections
RUN mkdir /var/run/sshd

# Disable password authentication and enable SSH key-based authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Set environment variable for the SSH port
EXPOSE ${SSH_PORT}

# Set the working directory
WORKDIR /workspace

# Start SSH and keep the container running
CMD ["/usr/sbin/sshd", "-D"]
