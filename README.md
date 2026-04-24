# ARIA SOC Pipeline

An automated open-source SOC pipeline built on a $9/month VPS. Wazuh detects threats, Shuffle automates the response, and TheHive manages cases — all without manual intervention.

## Architecture
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

## Memory Management

RAM watchdog service auto-remediates when available memory drops below 1GB. Memory limits enforced per container.

## Key Files

- docker-compose.yml — full stack definition with memory limits
- scripts/ram-watchdog.sh — auto RAM remediation
- scripts/connect_workers.sh — Shuffle worker network fix
- scripts/soc-startup.sh — clean startup script

## What I Learned

- Docker networking between spawned containers requires explicit network assignment
- Java heap limits must be set at both JVM and container level
- Open source SOC tooling can replace commercial solutions at a fraction of the cost

## Author

Abdullaah Yaseen — Yaseen Enterprise LLC
[@abdullaahyaseen](https://x.com/abdullaahyaseen)
