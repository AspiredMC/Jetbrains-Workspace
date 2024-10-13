#!/bin/bash

# Set the SSH host key directory
KEY_DIR="/home/container/sshd"

# Check for SSH host keys and generate them if not found
if [ ! -f "${KEY_DIR}/ssh_host_rsa_key" ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -A -f "${KEY_DIR}/ssh_host_" # Generate keys in the specified directory
    chmod 600 ${KEY_DIR}/ssh_host_*_key
    chmod 644 ${KEY_DIR}/ssh_host_*_key.pub
fi

# Start the SSH daemon
echo "Starting SSH daemon on port ${SSH_PORT}..."
/usr/sbin/sshd -D -p ${SSH_PORT} -f ${KEY_DIR}/sshd_config
