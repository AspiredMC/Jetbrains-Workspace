# Use a base image with SSH support, e.g., Ubuntu or Debian
FROM ubuntu:20.04

# Set the timezone environment variable
ENV TZ=America/New_York

# Install necessary packages and set up tzdata in non-interactive mode
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-server sudo docker.io tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure the timezone
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone

# Create the directory for SSHD and the host key directory
RUN mkdir -p /home/container/sshd && \
    mkdir /var/run/sshd && \
    echo 'root:rootpassword' | chpasswd

# Allow root login via SSH (not recommended for production environments)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Allow password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set default SSH port to 2007
ENV SSH_PORT=2007

RUN adduser -D -h /home/container container

WORKDIR /home/container

# Copy SSH configuration template to the new directory
COPY sshd_config /home/container/sshd/sshd_config

# Generate SSH host keys in the specified directory
RUN ssh-keygen -t rsa -f /home/container/sshd/ssh_host_rsa_key -N '' && \
    ssh-keygen -t ecdsa -f /home/container/sshd/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -t ed25519 -f /home/container/sshd/ssh_host_ed25519_key -N ''

# Set permissions for the generated keys
RUN chmod 600 /home/container/sshd/ssh_host_*_key && \
    chmod 644 /home/container/sshd/ssh_host_*_key.pub

# Copy the entrypoint script and set permissions
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose the SSH port
EXPOSE ${SSH_PORT}

# Set up a non-root user (for safety and convenience)
RUN adduser -h /home/container -ms /bin/bash pterodactyl && echo 'pterodactyl:pteropassword' | chpasswd
RUN usermod -aG sudo pterodactyl

# Enable Docker inside the container
RUN usermod -aG docker pterodactyl

USER pterodactyl

# Start the SSH service with custom entrypoint script
CMD ["/usr/local/bin/start.sh"]
