#!/bin/bash
THRESHOLD=1024  # MB - trigger if available RAM drops below 1GB

while true; do
  AVAILABLE=$(free -m | awk '/^Mem:/{print $7}')
  
  if [ "$AVAILABLE" -lt "$THRESHOLD" ]; then
    echo "$(date) - Low RAM detected: ${AVAILABLE}MB. Remediating..." >> /var/log/ram-watchdog.log
    
    # Clear swap
    swapoff -a && swapon -a
    
    # Kill tenzir if running
    docker rm -f tenzir-node 2>/dev/null
    
    # Clean orphaned worker containers
    docker ps -a --format '{{.Names}}' | grep "^worker-" | xargs docker rm -f 2>/dev/null
    
    # Drop caches
    sync && echo 3 > /proc/sys/vm/drop_caches
    
    echo "$(date) - Remediation complete. Available: $(free -m | awk '/^Mem:/{print $7}')MB" >> /var/log/ram-watchdog.log
  fi
  
  sleep 60
done
