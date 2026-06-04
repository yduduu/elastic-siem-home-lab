# Incident Response Report
## IR-2026-001 — PowerShell Execution Detected

| Field | Details |
|---|---|
| **Report ID** | IR-2026-001 |
| **Date** | June 4, 2026 |
| **Analyst** | yduduu |
| **Severity** | Medium |
| **Status** | Closed — False Positive |
| **Host** | dudu (Windows 11) |
| **User** | Asus |

---

## 1. Executive Summary

On June 4, 2026, the Elastic SIEM detection rule "PowerShell Execution Detected" generated 4 Medium severity alerts on host `dudu`. The alerts were triggered by the execution of `powershell.exe` processes captured via Windows Security Event ID 4688 (Process Creation). Investigation confirmed the activity was authorized lab testing. No malicious activity was identified. Alerts were closed as False Positive.

---

## 2. Detection Details

| Field | Value |
|---|---|
| **Rule Name** | PowerShell Execution Detected |
| **Rule Type** | Custom KQL Query |
| **Query** | `event.code:4688 AND process.name:("powershell.exe" OR "pwsh.exe")` |
| **MITRE ATT&CK** | T1059.001 — Command and Scripting Interpreter: PowerShell |
| **Severity** | Medium |
| **Risk Score** | 47 |
| **Alert Count** | 4 |
| **First Alert** | Jun 4, 2026 @ 15:33:00.885 |
| **Last Alert** | Jun 4, 2026 @ 15:33:00.910 |

---

## 3. Timeline of Events

| Time (UTC+8) | Event |
|---|---|
| 15:31:39 | Winlogbeat collected Event ID 4688 — powershell.exe process created on host dudu |
| 15:33:00 | Detection rule executed scheduled scan |
| 15:33:00 | 4 alerts generated in Kibana Security — Severity: Medium |
| 15:35:00 | Analyst opened and reviewed alert detail in Kibana |
| 15:36:00 | Investigation note added documenting findings |
| 15:37:00 | Alert closed as False Positive |

---

## 4. Forensic Evidence

### 4.1 Process Information

| Field | Value |
|---|---|
| `event.code` | 4688 |
| `event.action` | created-process |
| `event.category` | process |
| `event.dataset` | system.security |
| `process.name` | powershell.exe |
| `process.parent.name` | powershell.exe |
| `user.name` | Asus |
| `host.name` | dudu |
| `event.created` | Jun 4, 2026 @ 15:31:39.896 |
| `elastic_agent.version` | 8.18.0 |
| `event.agent_id_status` | verified |

### 4.2 Alert Reason (Kibana)

> "process event with process powershell.exe, parent process powershell.exe, by Asus on dudu created medium alert PowerShell Execution Detected."

### 4.3 Commands Executed (Lab Activity)

The following PowerShell commands were intentionally run to simulate attacker reconnaissance and test the detection rule:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Write-Host 'SIEM Lab Test'"
powershell.exe -NoProfile -Command "Get-Process"
powershell.exe -NoProfile -Command "Get-LocalUser"
powershell.exe -NoProfile -Command "whoami"
```

These commands simulate common post-exploitation reconnaissance techniques used by attackers after initial access.

---

## 5. MITRE ATT&CK Mapping

| Field | Value |
|---|---|
| **Tactic** | Execution (TA0002) |
| **Technique** | T1059 — Command and Scripting Interpreter |
| **Sub-technique** | T1059.001 — PowerShell |
| **Description** | Adversaries may abuse PowerShell commands and scripts for execution. PowerShell is a powerful interactive command-line interface and scripting environment included in the Windows operating system. |

### Why PowerShell is High-Value for Detection

PowerShell is one of the most commonly abused tools in real-world attacks because:
- It is built into every modern Windows system (no installation needed)
- It can download and execute payloads in memory without touching disk
- It can disable security tools, modify registry, and move laterally
- It is used by threat actors including APT29, Lazarus Group, and ransomware operators

---

## 6. Analysis

### 6.1 Was This Malicious?

No. The PowerShell executions were intentionally triggered as part of a controlled lab exercise to:
- Validate that the custom detection rule was functioning correctly
- Confirm that Winlogbeat was shipping Event ID 4688 logs to Elasticsearch
- Demonstrate the end-to-end SIEM detection pipeline

### 6.2 What Would a Real Attack Look Like?

In a real incident, the same alert pattern would warrant deeper investigation including:
- Checking `process.command_line` for encoded commands (`-EncodedCommand`)
- Looking for PowerShell downloading from the internet (`IEX`, `DownloadString`, `WebClient`)
- Checking if the parent process is unusual (e.g., `winword.exe` spawning `powershell.exe`)
- Correlating with network logs for outbound connections
- Checking for persistence mechanisms in the registry or scheduled tasks

---

## 7. Indicators of Compromise (IOCs)

No malicious IOCs identified. The following were observed and confirmed as authorized lab activity:

| Type | Value | Status |
|---|---|---|
| Process | powershell.exe | Authorized |
| User | Asus | Authorized |
| Host | dudu | Authorized |
| Event ID | 4688 | Expected |

---

## 8. Remediation and Recommendations

Since this was a False Positive from authorized lab activity, no remediation is required. However, for a real environment, the following recommendations apply when PowerShell execution is detected:

1. **Enable PowerShell Script Block Logging** (Event ID 4104) to capture full command content
2. **Enable PowerShell Module Logging** to record all pipeline execution
3. **Implement Application Whitelisting** to block unauthorized PowerShell usage
4. **Use Constrained Language Mode** to limit PowerShell capabilities for standard users
5. **Alert on encoded PowerShell** (`-EncodedCommand` flag) as high severity
6. **Correlate with network logs** — PowerShell downloading from external IPs is high confidence malicious

---

## 9. Lessons Learned

| Finding | Action |
|---|---|
| Detection rule successfully identified PowerShell execution | Rule is working as intended |
| Alert fired within 5 minutes of execution | Detection latency is acceptable for this lab |
| Event ID 4688 provides sufficient process creation data | Winlogbeat configuration is correct |
| Parent process was also powershell.exe | In real incidents, unusual parent processes are a key escalation indicator |

---

## 10. Conclusion

The Elastic SIEM detection pipeline functioned correctly end-to-end. The custom detection rule "PowerShell Execution Detected" successfully identified process creation events matching `powershell.exe` via Windows Event ID 4688, generated timely alerts in Kibana Security, and provided sufficient forensic data for investigation and triage. This lab exercise validated the full SOC workflow from log ingestion through alert closure.

---

*Report prepared by: yduduu | Elastic SIEM Home Lab | June 2026*
