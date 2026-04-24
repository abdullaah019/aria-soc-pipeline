#!/bin/bash
cd /home/abdullaah/soc-stack
# Remove any stale containers
docker ps -a | grep "Exit" | awk '{print $1}' | xargs docker rm -f 2>/dev/null
# Start the stack
docker-compose up -d
