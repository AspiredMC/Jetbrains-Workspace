#!/bin/bash

BIND_IP=${SERVER_IP:-0.0.0.0}
SSH_PORT=${SSH_PORT:-22}

echo "Port $SSH_PORT" >> /etc/ssh/sshd_config
echo "ListenAddress $BIND_IP" >> /etc/ssh/sshd_config

/usr/sbin/sshd -D
