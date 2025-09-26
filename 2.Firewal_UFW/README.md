# Basic Firewall Configuration with UFW (Kali in Docker)

## Objective
Configure a basic firewall inside a Kali Linux Docker container using UFW: allow SSH (22) and deny HTTP (80).

## How I ran it
1. Pulled Kali Docker image:
   `docker pull kalilinux/kali-rolling`
2. Started container with privileged mode and port mappings:
   `docker run -it --name kali-ufw --privileged -p 2222:22 -p 8080:80 -v <local-folder>:/workspace kalilinux/kali-rolling /bin/bash`
3. Installed `ufw` and other packages, started `sshd` for testing.
4. Ran `ufw_configuration.sh` (script included) which:
   - sets default deny incoming / allow outgoing
   - allows 22/tcp
   - denies 80/tcp
   - enables UFW non-interactively
5. Saved the `ufw status verbose` output to `/workspace/ufw_status.txt`.

## Files in repo
- `ufw_configuration.sh` — script that installs & configures UFW.
- `ufw_status.txt` or screenshot — UFW status output showing active rules.
- `README.md` — this file.

## Demo notes
- Test SSH: `ssh -p 2222 av@localhost` (password used during setup: `password`).
- Test HTTP: `curl -v http://localhost:8080` (should be blocked).

## Security note
Container is started with `--privileged` for demonstration only. Remove container after demo:
`docker stop kali-ufw && docker rm kali-ufw`
