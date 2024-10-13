# Use a base image with SSH support, e.g., Ubuntu or Debian
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    openssh-server sudo docker.io

# Set up SSH
RUN mkdir /var/run/sshd
RUN echo 'root:rootpassword' | chpasswd

# Allow root login via SSH (not recommended for production environments)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Allow password authentication
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set default SSH port
ENV SSH_PORT=22

# Expose the SSH port
EXPOSE ${SSH_PORT}

# Set up a non-root user (for safety and convenience)
RUN useradd -ms /bin/bash pterodactyl && echo 'pterodactyl:pteropassword' | chpasswd
RUN usermod -aG sudo pterodactyl

# Enable Docker inside the container
RUN usermod -aG docker pterodactyl

# Start the SSH service
CMD ["/usr/sbin/sshd", "-D", "-p", "${SSH_PORT}"]
