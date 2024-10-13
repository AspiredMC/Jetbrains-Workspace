# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package index and install required packages
RUN apt-get update -y && \
    apt-get install -y \
    openssh-server \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common && \
    # Install Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update -y && \
    apt-get install -y docker-ce && \
    # Clean up unnecessary files
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set up SSH
RUN mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose SSH and Docker ports
EXPOSE 2007

# Start SSH and keep the container running
CMD ["/usr/sbin/sshd", "-D", "-p", "2007"]
