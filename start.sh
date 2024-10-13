#!/bin/bash

# Set a default SSH port if not specified
SSH_PORT=${SSH_PORT:-2007}

# Ensure that the host keys are in the correct location
if [ ! -f /home/container/sshd/ssh_host_rsa_key ]; then
    echo "Host keys not found in /home/container/sshd, generating keys..."
    ssh-keygen -A
    cp /etc/ssh/ssh_host_* /home/container/sshd/
fi

# Start the SSH daemon from the new directory
echo "Starting SSH daemon on port ${SSH_PORT}..."
exec /usr/sbin/sshd -D -p "${SSH_PORT}" -f /home/container/sshd/sshd_config
