FROM php:8.2-cli

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

RUN mkdir /var/run/sshd

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

EXPOSE ${SSH_PORT}

WORKDIR /workspace

CMD ["/usr/sbin/sshd", "-D"]
