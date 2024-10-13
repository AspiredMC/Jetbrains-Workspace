#!/bin/bash

echo "Checking for SSH host keys..."

if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "No SSH host keys found. Generating SSH host keys..."
    ssh-keygen -A
    echo "SSH host keys generated."
else
    echo "SSH host keys already exist."
fi

# List the SSH host keys (for debugging)
echo "SSH host keys located at:"
ls -l /etc/ssh/ssh_host_*_key*

echo "Starting SSH daemon on port ${SSH_PORT}..."
exec /usr/sbin/sshd -D -p "${SSH_PORT}"
