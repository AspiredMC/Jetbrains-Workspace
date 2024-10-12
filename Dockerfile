FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

RUN apt-get update && apt-get install -y \
    software-properties-common \
    tzdata \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

RUN add-apt-repository ppa:ondrej/php \
    && apt-get update

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

RUN apt-get install -y \
    openssh-server \
    git \
    curl \
    wget \
    zip \
    unzip \
    build-essential \
    && apt-get clean

RUN mkdir /var/run/sshd \
    && echo 'root:rootpassword' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

RUN mkdir Workspace

RUN git clone https://github.com/AspiredMC/Jetbrains-Workspace.git Workspace

WORKDIR Workspace

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer install

EXPOSE ${SSH_PORT:-22}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
