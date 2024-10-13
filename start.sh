#!/bin/bash

service docker start
cd /var/www/$PROJECT_NAME
docker-compose up -d
