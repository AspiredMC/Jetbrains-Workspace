# Use a base image with SSH support, e.g., Ubuntu or Debian
FROM ubuntu:20.04

# Set the timezone environment variable (optional)
ENV TZ=America/New_York

# Install basic necessary packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openssh-server sudo tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure the timezone
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone

# Create directory for container operations
RUN mkdir -p /home/container

# Copy the install.sh script into the container
COPY install.sh /home/container/install.sh
RUN chmod +x /home/container/install.sh

# Expose SSH port (default or dynamic via script)
EXPOSE 2007

# Set working directory
WORKDIR /home/container

# Start by running the install script
ENTRYPOINT ["/home/container/install.sh"]
