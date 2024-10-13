#!/bin/bash

if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -A
fi

echo "Starting SSH daemon on port ${SSH_PORT}..."
exec /usr/sbin/sshd -D -p "${SSH_PORT}"
