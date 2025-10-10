# Network Security Assessment Report

**Author:** Arya Vikram Singh (AV)  
**Date:** 2025-10-11  
**Tools Used:** Nmap, Wireshark  
**Environment:** Local test network (synthetic data / authorized lab)

## Note on scope & authorization
All scanning and captures were performed in a controlled, authorized test environment. Do not run these procedures on production or third-party networks without explicit permission.

## 1. Objective
This assessment identifies and analyzes potential network vulnerabilities on a local/test network using Nmap for discovery and service enumeration and Wireshark for traffic capture and protocol analysis.

## 2. Methodology
- Nmap commands used (example):
  - Host discovery + service/version + OS detection:
    - nmap -sS -sV -O -oN nmap_results.txt 192.168.1.0/24
- Wireshark capture:
  - Capture duration: 15 minutes (controlled lab)
  - Capture filter example (BPF): host 192.168.1.2 or port 80
  - Display filter examples: http.request.method == "POST" ; smb.* ; dns.qry.name contains "adware"
- Analysis: triage findings, verify with packet evidence, assign severity, recommend remediations.

## 3. Findings (Summary & evidence)
1. Plaintext HTTP credentials observed in an HTTP POST to 192.168.1.2 (evidence: Wireshark HTTP POST packet, display filter http.request.method == "POST").  
   - Severity: High (credentials exposed on network).  
   - Immediate action: Rotate exposed credentials and enforce HTTPS (TLS) on the service.

2. SMB traffic showing legacy SMBv1 patterns between 192.168.1.2 and 192.168.1.3.  
   - Severity: High (SMBv1 is vulnerable to multiple severe exploits).  
   - Evidence: Wireshark SMB protocol negotiation packets indicating SMB1.  
   - Immediate action: Disable SMBv1 and migrate to SMBv2/SMBv3.

3. Suspicious DNS queries to adware-like domains originating from internal hosts.  
   - Severity: Medium.  
   - Evidence: DNS query logs in pcap and DNS query names matching known adware domains.  
   - Action: Isolate affected host(s), run malware scan, enable DNS filtering.

4. ARP broadcast anomalies (duplicate ARP replies / unexpected ARP traffic) suggest misconfiguration or a rogue device.  
   - Severity: Medium.  
   - Evidence: Repeated ARP replies for same IP with differing MACs in capture.  
   - Action: Check IP conflicts, inspect DHCP leases, run arp -a on hosts, and locate physical device.

## 4. Recommendations (practical fixes)

Immediate (within 24–72 hours)
- Enforce HTTPS/TLS for web services; do not send credentials in cleartext. Use valid certificates and HSTS.
- Rotate any credentials observed in plaintext.
- Disable SMBv1 on all systems:
  - Windows Server / Client (PowerShell, run as Admin):
    - Disable SMB1 on server: Set-SmbServerConfiguration -EnableSMB1Protocol $false
    - Disable SMB1 client: Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol
  - Samba (Linux): in /etc/samba/smb.conf under [global] add:
    - server min protocol = SMB2
    - client min protocol = SMB2
  - After changes, restart SMB services and verify with Wireshark / smbclient.

Short term (1–14 days)
- Isolate and scan hosts making suspicious DNS queries; run updated AV/endpoint scans.
- Implement DNS filtering (blocklists, Pi-hole, or DNS resolvers with filtering) and monitor.
- Investigate ARP anomalies: check for duplicate IPs, rogue DHCP, or misconfigured NICs; use arpwatch.

Medium term (2–8 weeks)
- Enforce host-based firewalls, restrict RDP and admin ports to management subnets or VPN only.
- Patch all systems and services; ensure automated patching where possible.
- Deploy IDS/IPS signatures for SMB/credential exfiltration and monitor alerts.

Long term / Policy
- Maintain an asset inventory and network segmentation to reduce blast radius.
- Enforce encryption for sensitive services and use centralized logging for network telemetry.
- Regularly schedule authenticated vulnerability scans and packet-capture exercises in lab.

## 5. Deliverables
- nmap_results.txt (scan output)
- wireshark_capture.pcap (synthetic / authorized capture)
- network_security_assessment.md (this file)

## 6. Verification steps
- Re-scan network after fixes (nmap) and re-capture traffic (Wireshark) to confirm:
  - No plaintext credentials on the wire.
  - SMB negotiation uses SMB2/SMB3.
  - DNS queries to adware domains stopped or quarantined.

## 7. Appendix — useful commands & filters
- Nmap example:
  - nmap -sS -sV -O -oN nmap_results.txt 192.168.1.0/24
- Wireshark capture filter (BPF):
  - host 192.168.1.2 or port 80
- Wireshark display filters:
  - http.request.method == "POST"
  - smb.flags.tree_connect
  - dns.qry.name contains "example"
