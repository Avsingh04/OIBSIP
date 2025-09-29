# Research Report: Common Network Security Threats

**Author:** Arya Vikram Singh (AV)
**Date:** 2025-09-29

## Executive summary

This report surveys common network security threats — how they work, their impacts, real-world examples, and practical mitigations. The goal is to give security practitioners and students a concise but thorough reference for defending networks against Denial-of-Service (DoS) and Distributed Denial-of-Service (DDoS) attacks, Man-in-the-Middle (MITM) attacks, spoofing attacks (ARP/IP/DNS/email), routing attacks such as BGP hijacking, and amplification/reflection attacks. It also provides a prioritized mitigation checklist and incident-response guidance.

## Table of contents
1. Introduction
2. Threat taxonomy and mechanisms
   - 2.1 DoS / DDoS attacks
   - 2.2 Amplification and reflection attacks
   - 2.3 Man-in-the-Middle (MITM) attacks
   - 2.4 Spoofing (IP, ARP, DNS, email)
   - 2.5 Routing attacks (BGP hijacking)
3. Impacts and risk assessment
4. Mitigation techniques (technical and operational)
5. Real-world examples and lessons learned
6. Preventive measures and best practices
7. Incident response and recovery
8. Conclusion

---

## 1. Introduction

Networks are the backbone of modern digital services. Threat actors exploit weaknesses at multiple layers — from link-layer protocols to application-layer trust — to intercept traffic, impersonate systems, or overwhelm resources. Understanding the attack mechanisms and available mitigations is crucial for building resilient systems.

## 2. Threat taxonomy and mechanisms

### 2.1 DoS and DDoS attacks
**How it works.** A Denial-of-Service (DoS) attack aims to make a service unavailable by exhausting resources (bandwidth, CPU, memory, concurrent sessions). When the attack is orchestrated from many distributed sources it is called Distributed DoS (DDoS).

**Attack vectors.** Volumetric floods (UDP, ICMP floods), protocol attacks (SYN floods, TCP-state-exhaustion), and application-layer floods (HTTP GET/POST floods) are common.

**Impact.** Service outages, revenue loss, reputational damage, collateral network congestion, and increased operational costs.

**Mitigation.** Rate limiting, traffic filtering, upstream scrubbing (DDoS protection services), autoscaling, SYN cookies, and network ingress filtering.

### 2.2 Amplification and reflection attacks
**How it works.** Attackers send small spoofed requests (with the victim's IP as source) to servers that reply with larger responses (NTP, DNS, Memcached historically). Because responses are larger (amplification factor), the victim is flooded with amplified traffic.

**Impact.** Extremely high bandwidth attacks with relatively low attacker resource cost.

**Mitigation.** Disable or patch vulnerable services (e.g., disable NTP MONLIST), implement ingress filtering (anti-spoofing / BCP38), rate limit UDP services, and use DDoS mitigation providers.

### 2.3 Man-in-the-Middle (MITM) attacks
**How it works.** MITM attacks place an attacker on the communication path (or trick endpoints) so the attacker can eavesdrop, modify, or inject traffic. Techniques include ARP poisoning on LANs, rogue Wi‑Fi access points, SSL/TLS downgrades or stripping (e.g., SSLStrip), and compromised routers or proxies.

**Impact.** Credential theft, session hijacking, data exfiltration, content tampering, and insertion of malware.

**Mitigation.** Enforce end-to-end encryption (TLS), use strong certificate validation, HSTS, mutual TLS where appropriate, avoid untrusted Wi‑Fi, use VPNs, implement 802.1X on enterprise LANs, and monitor for ARP anomalies.

### 2.4 Spoofing attacks
**IP spoofing.** Sending packets with forged source IP addresses to masquerade as another host — commonly used in amplification/reflection DDoS and session hijacking attempts.

**ARP spoofing (ARP poisoning).** On local Ethernet networks, attackers send forged ARP messages to associate the attacker's MAC with the IP of another host (e.g., the gateway), enabling MITM.

**DNS spoofing / cache poisoning.** Corrupting or poisoning DNS responses so victims resolve names to attacker-controlled hosts.

**Email / Sender spoofing.** Forging email headers to make messages appear from legitimate senders (used in phishing / BEC scams).

**Mitigation.** Implement BCP38/ingress filtering to prevent IP spoofing, use static ARP entries or dynamic ARP inspection/802.1X on critical subnets, DNSSEC for authoritative zones and DNSSEC-validating resolvers, SPF/DKIM/DMARC for email authentication, and network monitoring for anomalies.

### 2.5 Routing attacks: BGP hijacking
**How it works.** Border Gateway Protocol (BGP) relies on trust between autonomous systems. Malicious or mistaken route announcements can cause traffic to be rerouted (intercepted or black-holed).

**Impact.** Traffic interception, targeted surveillance, outages, and data exfiltration.

**Mitigation.** RPKI/ROA adoption, BGP monitoring and route filtering, prefix limit enforcement, and multi-path/dynamic routing resilience.

## 3. Impacts and risk assessment

Rank impact by confidentiality, integrity, and availability (CIA):
- DDoS primarily affects availability.
- MITM and spoofing affect confidentiality and integrity (and can enable availability attacks).
- Routing attacks can affect all three.

Organizations should perform threat modeling, business-impact analysis, and prioritize defenses for externally exposed services and critical internal infrastructure.

## 4. Mitigation techniques (technical and operational)

- **Network-layer defenses:** BCP38/ingress filtering, access control lists (ACLs), network segmentation, 802.1X, DHCP snooping, dynamic ARP inspection.
- **Transport/application-layer:** Enforce TLS for all services, use HSTS, implement strong cipher suites, use mutual TLS for sensitive links, input validation and bot-detection for web apps.
- **DDoS-specific:** Upstream scrubbing services, CDN + Anycast, rate limits, SYN cookies, stateful inspection tuning, UDP service hardening.
- **Authentication & email:** SPF, DKIM, DMARC, multi-factor authentication (MFA) everywhere.
- **Routing security:** RPKI, prefix filtering, BGP session protection (TTL security, MD5 where appropriate), monitoring with RPKI validators and BGP monitoring services.
- **Operational:** Patch management, secure device configuration, remove default credentials (especially on IoT), inventory of internet-facing assets, logging and SIEM, runbooked incident response.

## 5. Real-world examples and lessons learned

- **Mirai botnet / Dyn DDoS (2016):** IoT devices with default/weak credentials were conscripted into a botnet that generated massive DDoS traffic, disrupting major websites and services. Lesson: insecure default device configuration and lack of vendor security leads to large-scale outages.

- **Firesheep (2010) & SSLStrip (2009 demonstration):** Tools that demonstrated how easily session cookies and HTTPS protections can be circumvented on unencrypted or improperly configured sites — driving adoption of site-wide HTTPS and HSTS. Lesson: partial encryption (login-only HTTPS) is insufficient.

- **NTP amplification incidents (2014):** NTP servers with MONLIST enabled were abused for amplification attacks producing 100s of Gbps. Lesson: protocol features intended for diagnostics can become weapons; default service configuration must be conservative.

- **Pakistan / YouTube BGP incident (2008):** A route announcement intended to block access to YouTube accidentally propagated globally and caused large-scale reachability issues. Lesson: BGP trust model is fragile; operator safeguards and route filters are essential.

- **ARP spoofing / LAN MITM:** Frequent in open Wi‑Fi networks where attackers use ARP poisoning to intercept sessions. Lesson: never trust open network environments; use encryption and network access controls.

## 6. Preventive measures and best practices (prioritized checklist)

1. Harden internet-facing services: enforce TLS (site-wide), strong ciphers, HSTS, TLS 1.2+.
2. Deploy ingress filtering (BCP38) where possible and coordinate with upstream ISPs.
3. Use CDN and DDoS mitigation services for public-facing applications.
4. Implement SPF/DKIM/DMARC and require MFA for all privileged access.
5. Patch and inventory all devices, especially IoT and embedded systems; remove default passwords.
6. Enable DNSSEC on authoritative zones and use validating resolvers.
7. Implement network segmentation and least privilege for internal networks.
8. Monitor routing announcements and consider RPKI deployment.
9. Use DHCP snooping, dynamic ARP inspection, and 802.1X on enterprise LANs.
10. Maintain runbooks, exercise incident response, and capture forensic logs.

## 7. Incident response and recovery

- **Preparation:** Asset inventory, playbooks, contact lists (ISPs, upstream providers, DDoS scrubbing services), and backups.
- **Detection & analysis:** Use network telemetry (flow, packet capture), SIEM correlation, and BGP monitors to detect abnormal patterns.
- **Containment:** Apply ACLs/filters, coordinate with ISP, reroute traffic to scrubbing centers or blackhole (as last resort).
- **Eradication & recovery:** Patch exploited devices, rotate credentials, restore services from clean backups, and validate DNS/RPKI state.
- **Post-incident:** Root-cause analysis, update defenses and runbooks, disclosure and regulatory obligations if appropriate.

## 8. Conclusion

Network threats range from high-volume resource exhaustion (DDoS) to subtle traffic manipulation (MITM, spoofing, routing attacks). Defenses must be layered: harden endpoints and servers, secure transport with strong cryptography, apply network-layer hygiene to prevent spoofing, and prepare operationally with monitoring and response capabilities.

---

## Appendix A — Quick mitigation reference

- Ingress filtering (BCP38): prevent IP spoofing
- TLS + HSTS + strong cert validation: prevent SSL/TLS MITM
- SPF/DKIM/DMARC + MFA: reduce email spoofing and account compromise
- RPKI + route filtering: mitigate BGP hijacks
- CDNs & scrubbing services: mitigate volumetric DDoS
- DHCP snooping / DAI / 802.1X: mitigate LAN-level MITM

## Appendix B — Further reading

(Author may append curated links and references in the repository README.)

---

*End of report.*

