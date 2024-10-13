#!/bin/bash

# Define key directory
KEY_DIR="/home/container/sshd"

# Install any additional packages or perform post-install actions
echo "Installing additional packages..."
apt-get update && apt-get install -y docker.io

# Create the pterodactyl user and set up its home directory
if id "pterodactyl" &>/dev/null; then
    echo "User pterodactyl already exists."
else
    echo "Creating pterodactyl user..."
    useradd -m -d /home/container -s /bin/bash pterodactyl
    echo 'pterodactyl:pteropassword' | chpasswd
    usermod -aG sudo pterodactyl
    groupadd -f docker
    usermod -aG docker pterodactyl
fi

# Set up SSH keys and configuration
echo "Setting up SSH configuration..."

# Create SSH key directory if it doesn't exist
mkdir -p ${KEY_DIR}
cd ${KEY_DIR}

# Generate SSH host keys if not already present
if [ ! -f "${KEY_DIR}/ssh_host_rsa_key" ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -t rsa -f "${KEY_DIR}/ssh_host_rsa_key" -N ''
    ssh-keygen -t ecdsa -f "${KEY_DIR}/ssh_host_ecdsa_key" -N ''
    ssh-keygen -t ed25519 -f "${KEY_DIR}/ssh_host_ed25519_key" -N ''
else
    echo "SSH host keys already exist."
fi

# Configure SSH to use the correct key directory
sed -i "s|#HostKey /etc/ssh/ssh_host_rsa_key|HostKey ${KEY_DIR}/ssh_host_rsa_key|g" /etc/ssh/sshd_config
sed -i "s|#HostKey /etc/ssh/ssh_host_ecdsa_key|HostKey ${KEY_DIR}/ssh_host_ecdsa_key|g" /etc/ssh/sshd_config
sed -i "s|#HostKey /etc/ssh/ssh_host_ed25519_key|HostKey ${KEY_DIR}/ssh_host_ed25519_key|g" /etc/ssh/sshd_config

# Set permissions for SSH keys
chmod 600 ${KEY_DIR}/ssh_host_*_key
chmod 644 ${KEY_DIR}/ssh_host_*_key.pub

# Start SSH service
echo "Starting SSH daemon..."
/usr/sbin/sshd -D -p 2007
