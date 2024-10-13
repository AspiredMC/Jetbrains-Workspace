# Use a base image with SSH support
FROM ubuntu:20.04 AS builder

# Set the timezone environment variable
ENV TZ=America/New_York

# Install necessary packages and set up tzdata in non-interactive mode
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-server sudo docker.io tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create the home directory for the container and set it
RUN mkdir -p /home/container

# Copy the install script to the appropriate location
COPY install.sh /home/container/install.sh

# Ensure the install script has execution permissions
RUN chmod +x /home/container/install.sh

# Set up SSH keys and configuration
RUN mkdir -p /home/container/sshd && \
    ssh-keygen -A -f /home/container/sshd/ssh_host_ && \
    echo 'root:rootpassword' | chpasswd && \
    useradd -ms /bin/bash pterodactyl && \
    echo 'pterodactyl:pteropassword' | chpasswd && \
    usermod -aG sudo pterodactyl && \
    usermod -aG docker pterodactyl && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "Port 2007" >> /etc/ssh/sshd_config

# Expose the SSH port
EXPOSE 2007

# Set the working directory
WORKDIR /home/container

# Execute the install script when the container starts
CMD ["/home/container/install.sh"]
