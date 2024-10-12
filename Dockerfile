FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    apt-transport-https \
    ca-certificates \
    tzdata \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

# Add the GitHub CLI repository
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list \
    && apt-get update

RUN add-apt-repository ppa:ondrej/php \
    && apt-get update

RUN apt-get install -y \
    gh \
    openssh-server \
    git \
    wget \
    zip \
    unzip \
    build-essential \
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

RUN mkdir /var/run/sshd \
    && echo 'root:rootpassword' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

RUN mkdir Workspace

ARG GITHUB_TOKEN

RUN git clone https://$GITHUB_TOKEN@github.com/AspiredMC/Jetbrains-Workspace

WORKDIR Jetbrains-Workspace

EXPOSE ${SSH_PORT:-22}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
