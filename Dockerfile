FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    openssh-server \
    git \
    curl \
    wget \
    zip \
    unzip \
    build-essential \
    software-properties-common \
    && apt-get clean

RUN add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y \
    php8.0 \
    php8.0-cli \
    php8.0-common \
    php8.0-xml \
    php8.0-mbstring \
    php8.0-curl \
    php8.0-zip \
    php8.0-mysql \
    && apt-get clean

RUN mkdir /var/run/sshd
RUN echo 'root:rootpassword' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

EXPOSE ${SSH_PORT:-22}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
