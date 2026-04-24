#!/bin/bash
while true; do
  for container in $(sudo docker ps --format '{{.Names}}' | grep "^worker-"); do
    sudo docker network connect soc-stack_soc-net $container 2>/dev/null
  done
  sleep 2
done
