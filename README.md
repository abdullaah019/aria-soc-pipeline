# ARIA SOC Pipeline

An automated open-source SOC pipeline built on a $9/month VPS. Wazuh detects threats, Shuffle automates the response, and TheHive manages cases — all without manual intervention.

## Architecture

## Screenshots

### Wazuh Dashboard — Live Threat Detection
![Wazuh Dashboard](F3.png)

### Shuffle Workflow — Automated Pipeline
![Shuffle Workflow](F1.png)

### TheHive — Auto-Created Alert Detail
![TheHive Alert](F2.png)

### ARIA — AI Agent Overnight Report via Telegram
![ARIA Telegram Report](F4.png)

## Stack

| Tool | Role | Version |
|------|------|---------|
| Wazuh | Threat detection and SIEM | 4.x |
| Shuffle | SOAR automation | Latest |
| TheHive | Alert and case management | 5.3 |
| ARIA | AI monitoring agent | OpenClaw |

## How It Works

1. Wazuh monitors agents and detects security events
2. Wazuh fires alerts to Shuffle via webhook
3. Shuffle processes the alert and creates a case in TheHive
4. TheHive stores the alert with title, full log, rule ID, and timestamp
5. ARIA monitors the stack and sends daily summaries via Telegram

## Infrastructure

- Contabo Cloud VPS 20 NVMe — 6 cores, 12GB RAM, 100GB NVMe
- Ubuntu 24.04
- Cost: ~$9/month
- Agents monitored: 2

## Deployment

```bash
cd soc-stack
sudo docker-compose up -d
```

## Top 5 Challenges & How We Solved Them

### 1. Shuffle Worker Containers Couldn't Reach the Backend
Shuffle spawns child Docker containers to execute workflow actions. These containers had no network access and couldn't resolve the `shuffle-backend` hostname, causing all executions to hang indefinitely.

**Fix:** Created a persistent systemd service (`shuffle-network-fix`) that automatically connects every new worker container to the `soc-stack_soc-net` Docker network within 2 seconds of it spawning.

### 2. RAM Exhaustion Crashing the Entire Stack
Running Wazuh, Shuffle, TheHive, and OpenSearch on 12GB RAM caused repeated OOM kills. The server crashed overnight with 300+ orphaned Docker containers consuming all available memory.

**Fix:** Added Docker `mem_limit` constraints per container, reduced Java heap sizes, created a RAM watchdog systemd service that auto-remediates when available memory drops below 1GB, and added a 2GB swap file as a safety buffer.

### 3. Shuffle Webhook Kept Trying to Authenticate Against the Cloud
Self-hosted Shuffle was routing webhook start requests to shuffler.io cloud instead of staying local, returning "Bad apikey. Requires Org authentication" errors.

**Fix:** Manually registered the webhook document directly in OpenSearch, updated the org's sync_features to enable webhooks, and set `SHUFFLE_DISABLE_CLOUD_SYNC=true` in the environment config.

### 4. OpenSearch Index Mappings Blocking Hook Updates
When trying to update the webhook document to link it to the correct workflow, OpenSearch rejected the update because the `workflows` field was mapped as `text` type but we were trying to store an array of objects.

**Fix:** Deleted and recreated the hook document with the correct field types, then restarted the backend to clear its in-memory cache.

### 5. Stale Docker Containers Blocking Stack Restarts
Every time Docker restarted, old containers with the `ContainerConfig` key missing from their image config would block `docker-compose up`, requiring manual identification and removal before the stack could start.

**Fix:** Created a startup script (`soc-startup.sh`) that automatically removes all exited containers before attempting `docker-compose up`, and added this to the system startup sequence.

## Key Files

- `docker-compose.yml` — full stack definition with memory limits
- `scripts/ram-watchdog.sh` — auto RAM remediation
- `scripts/connect_workers.sh` — Shuffle worker network fix
- `scripts/soc-startup.sh` — clean startup script
- `configs/wazuh-integration.conf` — Wazuh to Shuffle webhook config

## Author

Abdullaah Yaseen — Yaseen Enterprise LLC
[@abdullaahyaseen](https://x.com/abdullaahyaseen)

