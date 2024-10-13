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

# Create the directory for SSHD
RUN mkdir -p /home/container/sshd && \
    mkdir /var/run/sshd && \
    echo 'root:rootpassword' | chpasswd

# Allow root login via SSH (not recommended for production environments)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Allow password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set default SSH port to 2007
ENV SSH_PORT=2007

# Force SSH host keys creation
RUN ssh-keygen -A && \
    mv /etc/ssh/ssh_host_* /home/container/sshd/ && \
    chmod 600 /home/container/sshd/ssh_host_*_key && \
    chmod 644 /home/container/sshd/ssh_host_*_key.pub

# Copy SSH configuration to the new directory
COPY sshd_config /home/container/sshd/sshd_config

# Copy the entrypoint script and set permissions
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# Expose the SSH port
EXPOSE ${SSH_PORT}

# Set up a non-root user (for safety and convenience)
RUN useradd -ms /bin/bash pterodactyl && echo 'pterodactyl:pteropassword' | chpasswd
RUN usermod -aG sudo pterodactyl

# Enable Docker inside the container
RUN usermod -aG docker pterodactyl

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/start.sh"]
