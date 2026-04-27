# Network Infrastructure & Configuration

## Overview

This SOC pipeline runs on a single cloud VPS with multiple Docker-based services communicating over an isolated internal network. All external traffic passes through UFW before reaching any service.

## Server Specs

- Provider: Contabo Cloud VPS
- OS: Ubuntu 24.04
- Resources: 6 cores, 12GB RAM, 100GB NVMe
- Location: US East

## Network Architecture

### External Layer
All inbound internet traffic hits the server's public IP and is filtered by UFW before reaching any service. Monitored agents connect on port 1514 to register and send logs to Wazuh Manager. ARIA sends outbound messages to Telegram via the OpenClaw gateway.

### UFW Firewall Rules
The following ports are open:

| Port | Protocol | Purpose |
|------|----------|---------|
| 22 | TCP | SSH access |
| 443 | TCP | HTTPS |
| 1514 | TCP/UDP | Wazuh agent communication |
| 1515 | TCP | Wazuh agent enrollment |
| 3001 | TCP | Shuffle frontend |
| 5001 | TCP | Shuffle backend API |
| 9000 | TCP | TheHive |

Blocked IPs are managed by fail2ban and manually added rules for known brute-force sources.

### Docker Network
All SOC stack containers run on a custom bridge network called `soc-stack_soc-net`. This isolates inter-service communication from the host network and allows containers to resolve each other by name.

```bash
# View the network
sudo docker network inspect soc-stack_soc-net

# Manually connect a container
sudo docker network connect soc-stack_soc-net <container_name>
```

### Service Ports

| Service | Container Name | Port |
|---------|---------------|------|
| Wazuh Indexer | wazuh-indexer (system) | 9200 |
| Shuffle Frontend | shuffle-frontend | 3001 |
| Shuffle Backend | shuffle-backend | 5001 |
| Shuffle OpenSearch | shuffle-opensearch | 9200 (internal) |
| TheHive | thehive | 9000 |
| OpenClaw/ARIA | openclaw-gateway | 18789 |

---

## Setup Instructions

### 1. UFW Configuration
```bash
sudo ufw allow 22/tcp
sudo ufw allow 443
sudo ufw allow 1514
sudo ufw allow 1515
sudo ufw allow 3001
sudo ufw allow 5001
sudo ufw allow 9000
sudo ufw enable
sudo ufw status
```

### 2. Docker Network
The `soc-stack_soc-net` network is created automatically when you run `docker-compose up`. If containers lose connectivity, reconnect them manually:

```bash
sudo docker ps --format '{{.Names}}' | grep "^worker-" | \
  xargs -I{} sudo docker network connect soc-stack_soc-net {} 2>/dev/null
```

### 3. Shuffle Worker Network Fix
Shuffle spawns child containers for each workflow execution. These containers spawn without network access by default. A systemd service handles this automatically:

```bash
# View the service
sudo systemctl status shuffle-network-fix

# The script it runs
cat /usr/local/bin/connect_workers.sh
```

The service watches for new worker containers every 2 seconds and connects them to `soc-stack_soc-net` automatically.

### 4. Wazuh Agent Enrollment
To enroll a new agent:

On the agent machine (Windows):

On the agent machine (Linux):
```bash
sudo WAZUH_MANAGER='<your VPS IP>' apt-get install wazuh-agent
sudo systemctl start wazuh-agent
```

Verify enrollment on the server:
```bash
sudo /var/ossec/bin/agent_control -l
```

### 5. Wazuh Integration with Shuffle
The integration config lives in `/var/ossec/etc/ossec.conf`:

```xml
<integration>
  <name>shuffle</name>
  <hook_url>http://<VPS_IP>:3001/api/v1/hooks/webhook_<HOOK_ID></hook_url>
  <level>7</level>
  <alert_format>json</alert_format>
</integration>
```

After editing, restart the Wazuh manager:
```bash
sudo /var/ossec/bin/wazuh-control restart
```

---

## Memory Management

Running multiple Java-based services on a single server requires careful memory allocation. Each container has a hard memory limit set in `docker-compose.yml`:

| Container | Memory Limit | Java Heap |
|-----------|-------------|-----------|
| TheHive | 2GB | -Xms256m -Xmx512m |
| shuffle-opensearch | 1GB | -Xms512m -Xmx512m |
| shuffle-backend | 512MB | — |

### RAM Watchdog
A systemd service monitors available RAM every 60 seconds and auto-remediates when it drops below 1GB:

```bash
sudo systemctl status ram-watchdog
sudo cat /var/log/ram-watchdog.log
```

### Swap
A 2GB swap file provides a safety buffer:
```bash
# Check swap usage
free -h

# Clear swap manually
sudo swapoff -a && sudo swapon -a
```

---

## Data Retention

### Wazuh Indexer
Alerts are stored in daily OpenSearch indices. A cron job runs at 2AM daily and deletes indices older than 72 hours:

```bash
# View current indices
curl -sk "https://localhost:9200/_cat/indices?v&h=index,store.size,docs.count" \
  -u admin:<password> | grep wazuh

# Manually delete an old index
curl -sk -X DELETE "https://localhost:9200/wazuh-alerts-4.x-YYYY.MM.DD" \
  -u admin:<password>
```

### TheHive
TheHive logs are cleaned from the Docker volume every 72 hours via the same cron job.

---

## Troubleshooting

### Worker containers not connecting to network
```bash
sudo docker ps --format '{{.Names}}' | grep "^worker-" | \
  xargs -I{} sudo docker network connect soc-stack_soc-net {} 2>/dev/null
```

### Check all service connectivity
```bash
# Docker stack status
cd ~/soc-stack && sudo docker-compose ps

# Wazuh processes
sudo /var/ossec/bin/wazuh-control status

# Test TheHive
curl -s http://localhost:9000/api/status | head -1

# Test Shuffle
curl -s http://localhost:5001/api/v1/health | python3 -m json.tool | grep success

# Test Wazuh Indexer
curl -sk "https://localhost:9200/_cluster/health" -u admin:<password> | python3 -m json.tool | grep status
```

### Alerts not flowing to Shuffle
```bash
# Check integration log
sudo tail -10 /var/ossec/logs/integrations.log

# Verify webhook is active in Shuffle
# Go to http://<VPS_IP>:3001 → Wazuh → TheHive → Receive Wazuh Alert → Start
```

### OpenSearch won't start
Usually a memory issue. Free RAM first:
```bash
sudo swapoff -a && sudo swapon -a
sudo docker rm -f tenzir-node 2>/dev/null
sudo docker rm -f shuffle-opensearch
sudo docker-compose up -d shuffle-opensearch
sleep 90
sudo docker exec shuffle-opensearch curl -s http://localhost:9200/_cluster/health 2>/dev/null
```

### Stale containers blocking startup
```bash
sudo docker ps -a | grep "Exit" | awk '{print $1}' | xargs sudo docker rm -f 2>/dev/null
sudo docker-compose up -d
```
