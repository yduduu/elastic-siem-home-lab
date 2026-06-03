# 🛡️ Elastic SIEM Home Lab

A fully functional Security Information and Event Management (SIEM) lab built on Elastic Stack, deployed using Docker on Windows. This project simulates a real SOC (Security Operations Center) environment for threat detection, log analysis, and security monitoring.

\---

## 📌 Project Overview

This home lab demonstrates end-to-end SIEM capabilities including log ingestion, threat detection, alert generation, and security monitoring — mirroring what analysts do in enterprise SOC environments.

**Built by:** Young Li Vui  
**Date:** June 2026  
**Goal:** Internship portfolio project for Cybersecurity / SOC Analyst roles

\---

## 🏗️ Architecture

```
Windows Host (Your Machine)
│
├── Docker
│   ├── Elasticsearch        ← Log storage \& search engine
│   └── Kibana               ← Visualization \& SIEM dashboard
│
├── Winlogbeat               ← Windows Event Log collector
│   └── Sends logs → Elasticsearch
││
└── Windows Audit Policy
    ├── Event ID 4624        ← Successful Logon
    ├── Event ID 4688        ← Process Creation
    └── Event ID 1102        ← Audit Log Cleared
```

\---

## 🧰 Tools \& Technologies

|Tool|Purpose|
|-|-|
|Elasticsearch 8.18|Log storage, indexing, search|
|Kibana 8.18|SIEM dashboards, alerts, investigation|
|Docker|Container deployment|
|Winlogbeat|Windows Event Log collection|
|Windows Audit Policy|Process creation \& security logging|

\---

## ⚙️ Lab Setup

### Prerequisites

* Windows 10/11
* Docker Desktop installed
* PowerShell (Administrator)
* At least 8GB RAM

### 1\. Deploy Elasticsearch \& Kibana with Docker

```yaml
# docker-compose.yml
version: '3'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.18.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=true
      - ELASTIC\_PASSWORD=your\_password
    ports:
      - "9200:9200"

  kibana:
    image: docker.elastic.co/kibana/kibana:8.18.0
    environment:
      - ELASTICSEARCH\_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH\_USERNAME=kibana\_system
      - ELASTICSEARCH\_PASSWORD=your\_kibana\_password
    ports:
      - "5601:5601"
```

```powershell
docker compose up -d
```

### 2\. Configure Winlogbeat

Installed Winlogbeat on Windows host to collect:

* Security logs (4624, 4625, 4688, 1102)
* System logs
* PowerShell logs

```yaml
# winlogbeat.yml
winlogbeat.event\_logs:
  - name: Security
  - name: System
  - name: Microsoft-Windows-PowerShell/Operational

output.elasticsearch:
  hosts: \["localhost:9200"]
  username: "elastic"
  password: "your\_password"
```

### 3\. Enable Windows Process Creation Auditing

```powershell
auditpol /set /subcategory:"Process Creation" /success:enable
auditpol /get /subcategory:"Process Creation"
# Result: Success
```

### 4\. Install Detection Rules

In Kibana → Security → Rules → Add Elastic Rules

Installed **500+ prebuilt detection rules** including:

* PowerShell Script with Log Clear Capabilities
* Windows Event Logs Cleared
* Suspicious Execution via Windows Subsystem for Linux
* Privilege Escalation via Named Pipe Impersonation
* Encoded PowerShell Command

\---

## 🔍 Security Events Collected

|Event ID|Description|Status|
|-|-|-|
|4624|Successful Logon|✅ Collected|
|4625|Failed Logon|✅ Collected|
|4672|Special Privileges Assigned|✅ Collected|
|4688|Process Creation|✅ Collected|
|4798|User Group Enumeration|✅ Collected|
|1102|Audit Log Cleared|✅ Collected|
|5379|Credential Manager Read|✅ Collected|

\---

## 🚨 Alerts Generated

### Alert 1: Windows Event Logs Cleared

* **Rule:** Windows Event Logs Cleared
* **Severity:** Low
* **Risk Score:** 21
* **Triggered by:** `wevtutil cl Security`
* **Significance:** Log clearing is a common attacker anti-forensics technique (T1070.001 in MITRE ATT\&CK)

\---

## 📊 SIEM Capabilities Demonstrated

* ✅ **Log Ingestion** — Windows security events flowing into Elasticsearch
* ✅ **Log Storage \& Indexing** — winlogbeat-\* index with full ECS mapping
* ✅ **Threat Detection** — 500+ rules monitoring for malicious behavior
* ✅ **Alert Generation** — Real alerts triggered by simulated attack techniques
* ✅ **Dashboard Visualization** — Event distribution, source IPs, user activity
* ✅ **Log Investigation** — KQL queries in Kibana Discover

\---

## 🎯 Attack Simulations Performed

|Technique|Command|MITRE ATT\&CK|
|-|-|-|
|Log Clearing|`wevtutil cl Security`|T1070.001|
|Encoded PowerShell|`powershell -enc SQBFAFgA`|T1059.001|
|Execution Policy Bypass|`powershell -ExecutionPolicy Bypass`|T1059.001|
|System Enumeration|`whoami`, `ipconfig`, `net user`, `systeminfo`|T1082|

\---

## 📚 Key Learnings

* Deploying and configuring Elastic Stack in a containerized environment
* Understanding SIEM architecture and data flow
* Windows Security Event Log analysis
* Writing KQL queries for threat hunting
* Configuring and managing detection rules
* Simulating attacker techniques and observing SOC response workflow
* Windows Event and Elastic Agent deployment for EDR capabilities
* Detection Rule Configuration and Alert Investigation

\---

## 🔗 Related Projects

* Malware Analysis Lab
* Memory Forensics with Volatility
* Network Design with Cisco Packet Tracer
* Linux Administration

\---

## 📷 Screenshots



\# Elastic SIEM Home Lab



\## Process Creation Event Monitoring (Event ID 4688)



Windows Security Event ID 4688 was successfully collected by Winlogbeat and ingested into Elasticsearch.



!\[4688 Event](screenshots/process-creation-event-4688.png)



\---



\## Windows Event Logs Cleared Detection



Elastic Security generated an alert after detecting Windows Event ID 1102.



!\[1102 Alert](screenshots/windows-event-log-cleared-alert.png)



\---



\## Detection Rules



Prebuilt Elastic Security rules were installed and enabled.



!\[Detection Rules](screenshots/detection-rules.png)

## 📄 References

* [Elastic SIEM Documentation](https://www.elastic.co/guide/en/security/current/index.html)
* [Elastic Agent Documentation](https://www.elastic.co/guide/en/fleet/current/index.html)
* [MITRE ATT\&CK Framework](https://attack.mitre.org/)
* [Windows Security Event IDs](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/)

