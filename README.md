# ARIA — Autonomous Response & Intelligence Agent

![Status](https://img.shields.io/badge/Status-Production-brightgreen)
![Platform](https://img.shields.io/badge/Platform-SeenProtect-7C3AED)
![AI](https://img.shields.io/badge/AI-Claude%20claude--sonnet--4--5-orange)
![Stack](https://img.shields.io/badge/Stack-Wazuh%20%7C%20TheHive%20%7C%20Next.js-blue)

> Built a production SOC-as-a-Service platform on a $9/month VPS. Started as a homelab. Now a real product with paying clients.

**Live:** [seenprotect.com](https://seenprotect.com) • [portal.seenprotect.com](https://portal.seenprotect.com)

---

## What Is ARIA?

ARIA is an autonomous SOC pipeline that monitors endpoints 24/7, analyzes threats with Claude AI, creates cases in TheHive, alerts via Telegram, and generates compliance reports — without manual intervention.

Built for regulated SMBs (healthcare, legal, financial) that need enterprise-grade security but can't afford a full in-house SOC team.

---

## Architecture

```
Wazuh Agents (Windows / Linux / macOS / M365 / GCP)
                        ↓
              Wazuh Manager (VPS)
         47 custom rules • MITRE-mapped
                        ↓
              ARIA L2 Agent (Claude AI)
      MITRE mapping • CISA KEV • NIST CSF 2.0
                        ↓
    ┌───────────┬──────────┬──────────┬──────────┐
    │  TheHive  │ Telegram │ Supabase │  PDF     │
    │  Cases    │  Alerts  │    DB    │ Reports  │
    └───────────┴──────────┴──────────┴──────────┘
                        ↓
              Client Portal (Next.js 14)
          portal.seenprotect.com
```

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Endpoint Monitoring | Wazuh 4.14.4 (native, not Docker) |
| AI Analysis | Claude claude-sonnet-4-5 — Anthropic |
| Case Management | TheHive 5.3 (Docker) |
| Database | Supabase (PostgreSQL + RLS) |
| Real-time Alerts | Telegram Bot API |
| Email | Resend (aria@seenprotect.com) |
| PDF Reports | Puppeteer (HTML → PDF) |
| Client Portal | Next.js 14, Tailwind CSS, Vercel |
| Payments + Provisioning | Stripe Webhooks → auto-onboarding |
| M365 Monitoring | Microsoft Graph API (L1b poller) |
| GCP Monitoring | Security Command Center + Audit Logs |
| Infrastructure | Contabo VPS, Ubuntu 24, PM2, Nginx |

---

## Detection Coverage

**47 custom Wazuh rules mapped to MITRE ATT&CK:**

| Technique | Name | Category |
|-----------|------|----------|
| T1110.001 | Brute Force: Password Guessing | Credential Access |
| T1486 | Data Encrypted for Impact | Ransomware |
| T1078.004 | Valid Accounts: Cloud | Initial Access |
| T1566.002 | Phishing: Spearphishing Link | Initial Access |
| T1114.003 | Email Forwarding Rule | Collection |
| T1548 | Abuse Elevation Control | Privilege Escalation |
| T1136.003 | Create Account: Cloud | Persistence |
| T1562.004 | Impair Defenses: Firewall | Defense Evasion |
| T1496 | Resource Hijacking (Cryptomining) | Impact |
| T1611 | Escape to Host (Container) | Privilege Escalation |

**Compliance Frameworks:**
- ✅ NIST CSF 2.0 — all 6 functions (Identify, Protect, Detect, Respond, Recover, Govern)
- ✅ HIPAA Technical Safeguards — 164.312(a)(1), (b), (c)(1), (d), (e)(1)
- ✅ FTC Safeguards Rule

---

## Key Features

**🤖 Autonomous L2 Analysis**
Every alert is analyzed by Claude AI — MITRE technique mapped, CISA KEV checked, compliance impact assessed, root cause identified, and recommended actions generated. No human required for L1/L2 triage.

**📱 Smart Telegram Alerts**
14 attack category templates. Brute force alerts show source IP + attempt count. Ransomware alerts include ISOLATE warning. Each alert links directly to the TheHive case.

**🎫 Auto Case Lifecycle**
TheHive cases auto-created for critical/high/medium severity. Low/medium auto-closed with audit-ready closure notes. High/critical tracked with SLA timers.

**📊 Monthly PDF Reports**
Auto-generated on the 1st of each month. Includes alert summary, MITRE techniques detected, HIPAA compliance posture, and security score. Uploaded to Supabase Storage, emailed to client, available for download in portal.

**🏢 Client Portal**
Self-service dashboard showing escalated incidents only (no noise). Threat summaries written in plain language. Analyst response panel for SOC team. Onboarding hub with step-by-step Wazuh install instructions.

**💳 Stripe Auto-Provisioning**
Client pays → Stripe webhook fires → ARIA auto-creates Supabase account, TheHive org, and sends welcome email with portal credentials. Zero manual work.

---

## The Journey — v1 → v2

| | v1 (Original) | v2 (Current) |
|---|---|---|
| AI | ❌ None | ✅ Claude claude-sonnet-4-5 |
| Automation | Shuffle SOAR | Custom Node.js pipeline |
| Analysis | Rule-based only | MITRE + CISA KEV + NIST CSF |
| Threat Hunt | ❌ None | ✅ IOC correlation + kill chain |
| Client Facing | ❌ None | ✅ Full portal + onboarding hub |
| Reports | ❌ None | ✅ Auto PDF monthly reports |
| Payments | ❌ None | ✅ Stripe auto-provisioning |
| Cloud Monitoring | ❌ None | ✅ M365 + GCP pollers |
| VPS Cost | $9/month | $9/month (same hardware) |

---

## Infrastructure

| Component | Details |
|-----------|---------|
| VPS | Contabo, Ubuntu 24, 11GB RAM, 96GB disk |
| Wazuh | 4.14.4 native (not Docker), ports 1514/1515 |
| ARIA Engine | Node.js, PM2, port 4000 |
| TheHive | 5.3, Docker, port 9000 |
| Reverse Proxy | Nginx + SSL (Let's Encrypt) |
| Domains | seenprotect.com • portal.seenprotect.com • app.seenprotect.com |

**ARIA Engine files:**

| File | Purpose |
|------|---------|
| index.js | Express server + routing |
| l2-agent.js | Claude AI threat analysis |
| threat-hunt.js | IOC correlation + kill chain |
| case-manager.js | TheHive case lifecycle |
| report-generator.js | Puppeteer PDF generation |
| stripe-webhook.js | Auto client provisioning |
| m365-poller.js | Microsoft Graph monitoring |
| gcp-poller.js | GCP Security Command Center |

---

## Repos

| Repo | Description |
|------|-------------|
| [aria-provisioning](https://github.com/abdullaah019/aria-provisioning) | Core ARIA engine |
| [aria-portal](https://github.com/abdullaah019/aria-portal) | Client portal (Next.js 14) |
| [seenprotect-landing](https://github.com/abdullaah019/seenprotect-landing) | Landing page |

---

## Author

**Abdullaah Yaseen** — SOC Analyst & Founder, SeenProtect

CompTIA Security+ • CySA+ • AZ-500 • SC-300

[seenprotect.com](https://seenprotect.com) • [LinkedIn](https://linkedin.com/in/abdullaahyaseen)

---

*Started as a $9/month homelab experiment. Built into a production SOC platform serving regulated SMBs.*
