# SQL Injection (DVWA, Low) — Short Report

## Summary
Target: DVWA (Security level: Low).  
A SQL injection vulnerability was identified in the login form of a local DVWA instance. Using UNION-based techniques I enumerated table columns and retrieved user-related rows (usernames and password hashes) for analysis in a controlled environment.

## Scope and responsible use
- Test only on systems you own or are explicitly authorized to test (for example, a local DVWA instance).
- Do not run these techniques against third-party systems or production services.
- This document omits exact exploit strings and commands; replace placeholders with your controlled test payloads only in an authorized environment.

## High-level methodology
- Confirm the injection point in the login form.
- Use a UNION-style query to discover columns and table structure (information_schema).
- Enumerate rows (for example, using LIMIT with offsets) to extract records.
- Parse saved responses to recover usernames and password hashes.
- Document findings and recommend remediation (parameterized queries, input validation, least privilege).

## Example workflow (safe, placeholder-based)
1. Start DVWA (local container).
2. Confirm access: http://localhost:8080 (default DVWA credentials: admin / password).
3. Use a scripted POST request to submit controlled test payloads and save responses.
4. Iterate row offsets and parse saved responses to extract data.

Example curl template (replace placeholders):
```bash
curl -s -c cookies.txt -b cookies.txt \
  --data-urlencode "username=<INJECTION_PAYLOAD>" \
  --data-urlencode "password=<PASSWORD>" \
  --data "Login=Login" -X POST "http://localhost:8080/dvwa/login.php" -o result.html
```

## Notes
- Do not publish or share exploit payloads or extracted sensitive data from systems you do not own.
- When testing, keep logs and artifacts local and report vulnerabilities to the owner with remediation steps.

