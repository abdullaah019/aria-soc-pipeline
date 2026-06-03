# ARIA SOC Pipeline — v2.0

> **This project has evolved significantly.** What started as a $9/month VPS running Wazuh + Shuffle + TheHive has become a full AI-powered SOC-as-a-Service platform. See below for the full journey.

---

## 🚀 What ARIA Is Today

ARIA (Autonomous Response & Intelligence Agent) is a production SOC-as-a-Service platform powering **SeenProtect** — managed security for regulated SMBs (healthcare, legal, financial).

**Live Platform:** [seenprotect.com](https://seenprotect.com)

### How It Works

---

## 🛠 Tech Stack

| Component | Technology |
|-----------|-----------|
| Endpoint Monitoring | Wazuh 4.14.4 |
| AI Analysis Engine | Claude claude-sonnet-4-5 (Anthropic) |
| Case Management | TheHive 5.3 |
| Database | Supabase (PostgreSQL) |
| Real-time Alerts | Telegram Bot API |
| Email | Resend |
| PDF Reports | Puppeteer (HTML → PDF) |
| Client Portal | Next.js 14, Tailwind CSS, Vercel |
| Payments | Stripe |
| Cloud Monitoring | Microsoft Graph API (M365), GCP Security Command Center |
| Infrastructure | Contabo VPS, Ubuntu 24 |

---

## 🔍 Detection Coverage

**MITRE ATT&CK Techniques:**
T1110 (Brute Force) • T1486 (Ransomware) • T1078 (Valid Accounts) • T1566 (Phishing) • T1114 (Email Collection) • T1548 (Privilege Escalation) • T1136 (Create Account) • T1562 (Impair Defenses) • T1496 (Resource Hijacking) • T1611 (Container Escape) • T1530 (Cloud Storage) • T1021 (Remote Services)

**Compliance Frameworks:**
- NIST CSF 2.0 (Identify, Protect, Detect, Respond, Recover, Govern)
- HIPAA Technical Safeguards (164.312)
- FTC Safeguards Rule

---

## ⚡ Key Features

- **Autonomous L2 Analysis** — Claude AI maps every alert to MITRE ATT&CK, CISA KEV, and compliance frameworks
- **14 Attack Category Templates** — dynamic Telegram alerts tailored by attack type
- **Auto Case Lifecycle** — TheHive cases auto-created, managed, and closed with audit-ready notes
- **Monthly PDF Reports** — auto-generated, uploaded to Supabase Storage, emailed to clients
- **Client Portal** — self-service dashboard at portal.seenprotect.com
- **Stripe Auto-Provisioning** — payment → instant client account creation
- **M365 + GCP Monitoring** — cloud identity and infrastructure threat detection
- **Multi-Client Architecture** — isolated per-client data with RLS

---

## 📈 The Journey — v1 → v2

| | v1 (Original) | v2 (Current) |
|---|---|---|
| AI | None | Claude claude-sonnet-4-5 |
| Automation | Shuffle SOAR | Custom Node.js pipeline |
| Analysis | Rule-based only | MITRE + CISA KEV + NIST |
| Client facing | None | Full portal + onboarding |
| Reports | None | Auto PDF monthly reports |
| Payments | None | Stripe integration |
| Cloud monitoring | None | M365 + GCP pollers |
| Cost | $9/month VPS | $9/month VPS (same hardware) |

---

## 🏗 Infrastructure

- **VPS:** Contabo, Ubuntu 24, 11GB RAM, 96GB disk
- **Stack:** PM2 + Nginx + Docker (TheHive) + Wazuh (native)
- **Subdomains:** seenprotect.com • portal.seenprotect.com • app.seenprotect.com

---

## 📁 Repos

| Repo | Description |
|------|-------------|
| [aria-provisioning](https://github.com/abdullaah019/aria-provisioning) | Core ARIA engine — L2 agent, Stripe webhook, report generator |
| [aria-portal](https://github.com/abdullaah019/aria-portal) | Client portal — Next.js 14, Supabase auth |
| [seenprotect-landing](https://github.com/abdullaah019/seenprotect-landing) | Landing page |

---

## 👤 Author

**Abdullaah Yaseen** — SOC Analyst & Founder, SeenProtect  
CompTIA Security+ • CySA+ • AZ-500 • SC-300  
[seenprotect.com](https://seenprotect.com) • [LinkedIn](https://linkedin.com/in/abdullaahyaseen)

---

*Built in public. Started as a $9/month homelab. Now a production SOC platform.*
