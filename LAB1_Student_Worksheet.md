# Lab 1: Vulnerable Smart Home Demo
## Student Worksheet

### Learning Objectives
- Identify common IoT security vulnerabilities
- Understand the OWASP IoT Top 10
- Practice security assessment techniques
- Document security findings professionally

---

## Part 1: Initial Setup (15 minutes)

### Prerequisites
- Raspberry Pi 4 with Raspbian OS
- Network connection
- Web browser
- Terminal access

### Setup Instructions
1. Connect to your Raspberry Pi via SSH or directly
2. Download the lab files from the instructor
3. Run the setup script:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```
4. Start the application:
   ```bash
   python3 vulnerable_iot_app.py
   ```
5. Find your Raspberry Pi's IP address:
   ```bash
   # Method 1: If you're on the Pi directly
   hostname -I | awk '{print $1}'
   
   # Method 2: Show all network interfaces
   ip addr show | grep "inet "
   
   # Method 3: Alternative command
   ifconfig | grep "inet "
   ```
   Your IP will likely be something like `192.168.1.X` or `10.0.0.X`
   
6. Access the web interface from any browser on the same network:
   - Main page: `http://<pi-ip>:5000`
   - Example: `http://192.168.1.105:5000`
   
7. Verify the application is running:
   ```bash
   # Check if the port is listening
   netstat -tln | grep 5000
   ```

---

## Part 2: Reconnaissance (20 minutes)

### Task 1: Information Gathering
Without logging in, explore the application and document:

- [ ] What version information is visible?
- [ ] What endpoints/URLs can you discover?
- [ ] What information is in the HTML source code?
- [ ] What's visible in browser developer tools?
- [ ] What files are publicly accessible?

**Document your findings:**
```
Version: _______________
Endpoints discovered:
1. _______________
2. _______________
3. _______________

Interesting findings:
_______________________
_______________________
```

### Task 2: Network Analysis
Use basic tools to analyze the application:

```bash
# Port scan
nmap -p 1-10000 localhost

# Check running services
netstat -tulpn

# View network traffic (in another terminal)
tcpdump -i any -A 'port 5000'
```

**What ports are open? What services are running?**
_______________________

---

## Part 3: Vulnerability Assessment (45 minutes)

### Vulnerability Checklist
Find and exploit the following vulnerabilities. Document how you found each one and its potential impact.

#### Authentication & Authorization
- [ ] **V1: Weak/Default Credentials**
  - Method: _______________________
  - Credentials found: _______________________
  - Impact: _______________________

- [ ] **V2: Insecure Authentication**
  - Token/Session issue: _______________________
  - How to exploit: _______________________

- [ ] **V3: Missing Authentication**
  - Unprotected endpoints: _______________________
  - Sensitive data exposed: _______________________

#### Data Protection
- [ ] **V4: Sensitive Data in Plaintext**
  - Where found: _______________________
  - What data: _______________________

- [ ] **V5: Information Disclosure**
  - Verbose errors: _______________________
  - Debug information: _______________________

- [ ] **V6: Insecure Data Storage**
  - Client-side storage: _______________________
  - Database issues: _______________________

#### Input Validation
- [ ] **V7: SQL Injection**
  - Vulnerable parameter: _______________________
  - Payload used: _______________________
  - Data extracted: _______________________

- [ ] **V8: Command Injection**
  - Vulnerable function: _______________________
  - Command executed: _______________________
  - Proof: _______________________

#### Configuration Issues
- [ ] **V9: Insecure Network Services**
  - Unnecessary ports: _______________________
  - Misconfigurations: _______________________

- [ ] **V10: Hardcoded Secrets**
  - Location: _______________________
  - Secrets found: _______________________

### Bonus Vulnerabilities
Can you find these additional issues?

- [ ] Directory traversal
- [ ] Cross-Site Scripting (XSS)
- [ ] CORS misconfiguration
- [ ] Weak cryptography
- [ ] Missing security headers

---

## Part 4: Exploitation Exercises (30 minutes)

### Exercise 1: Gain Admin Access
Find at least 3 different ways to gain admin access:

1. Method: _______________________
   Steps: _______________________

2. Method: _______________________
   Steps: _______________________

3. Method: _______________________
   Steps: _______________________

### Exercise 2: Extract Sensitive Data
Extract the following information from the system:

- [ ] API keys
- [ ] WiFi credentials
- [ ] User database
- [ ] System configuration

**Data found:**
```
API Key: _______________
WiFi Password: _______________
Other: _______________
```

### Exercise 3: Remote Code Execution
Achieve remote code execution on the system:

**Payload used:**
```
_______________________
```

**Proof (command output):**
```
_______________________
```

---

## Part 5: Security Report (20 minutes)

### Vulnerability Summary
Create a professional vulnerability report:

| Vulnerability | Severity | Location | Impact | Remediation |
|--------------|----------|----------|---------|-------------|
| Example: Hardcoded Password | Critical | app.py:15 | Full system compromise | Use environment variables |
| | | | | |
| | | | | |
| | | | | |
| | | | | |
| | | | | |

### Risk Assessment
Rate the overall security posture:
- [ ] Critical - Immediate action required
- [ ] High - Significant vulnerabilities present
- [ ] Medium - Some concerning issues
- [ ] Low - Minor issues only

**Justification:** _______________________

---

## Part 6: Remediation Planning (15 minutes)

### Priority Fixes
List the top 5 vulnerabilities that should be fixed first:

1. **Vulnerability:** _______________________
   **Fix:** _______________________

2. **Vulnerability:** _______________________
   **Fix:** _______________________

3. **Vulnerability:** _______________________
   **Fix:** _______________________

4. **Vulnerability:** _______________________
   **Fix:** _______________________

5. **Vulnerability:** _______________________
   **Fix:** _______________________

### Security Recommendations
Provide recommendations for improving the overall security:

**Immediate actions:**
- _______________________
- _______________________

**Short-term improvements:**
- _______________________
- _______________________

**Long-term security strategy:**
- _______________________
- _______________________

---

## Submission Requirements

1. Completed worksheet (this document)
2. Screenshot evidence of exploits
3. Brief presentation (5 minutes) on most critical finding
4. Optional: Proof-of-concept code for automated exploitation

## Grading Rubric

| Component | Points |
|-----------|--------|
| Vulnerabilities Found (15 @ 2pts) | 30 |
| Exploitation Exercises | 20 |
| Security Report Quality | 20 |
| Remediation Planning | 15 |
| Presentation | 10 |
| Bonus Findings | 5 |
| **Total** | **100** |

---

## Ethical Guidelines

⚠️ **Remember:**
- This lab is for educational purposes only
- Never test these techniques on systems you don't own
- Always obtain written permission before security testing
- Report vulnerabilities responsibly
- Respect privacy and confidentiality

**Honor Code Agreement:**
I understand that the techniques learned in this lab are powerful and potentially dangerous. I agree to use this knowledge ethically and legally, only on systems I own or have explicit permission to test.

Signature: _______________________ Date: _____________