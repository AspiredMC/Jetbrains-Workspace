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

# Execute the install script when the container starts
CMD ["/home/container/install.sh"]
