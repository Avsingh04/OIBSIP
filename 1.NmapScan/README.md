# Nmap Scan Results

This document provides the results of a basic network scan conducted using Nmap.

## Scan Information
- **Target IP**: 10.136.64.232
- **Scan Type**: Basic port scan and service version detection
- **Tools Used**: Nmap on Windows

## Results
The following ports were open on the target machine:

- **Port 135 (SSH)**: OpenSSH 7.6p1 (Used for secure remote access)
- **Port 139 (HTTP)**: Microsoft Windows netbios-ssn
- **Port 443 (HTTPS)**: Apache HTTPD 2.4.29 (Secure web server)
- **Port 2869 (MySQL)**: MySQL 5.7.31 (Database service)
- **Port 3306 (PostgreSQL)**: PostgreSQL DB 12.3 (Database service)

## Conclusion

The target machine has several key services exposed, including:
- **SSH** (remote access),
- **Apache web servers** (HTTP/HTTPS),
- **MySQL and PostgreSQL** (database services).

## Security Recommendations
- Use strong SSH passwords and consider implementing key-based authentication.
- Ensure that the Apache and MySQL servers are regularly updated.
- Restrict access to database ports (3306 and 5432) via a firewall.
