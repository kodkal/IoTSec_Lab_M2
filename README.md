# IoT Security Lab 1: Vulnerable Smart Home Demo

## Overview
This lab provides a hands-on introduction to IoT security vulnerabilities through a intentionally vulnerable smart home temperature monitoring system. Students will learn to identify, exploit, and remediate common IoT security issues.

**⚠️ WARNING: This application is intentionally vulnerable for educational purposes. DO NOT deploy in production or on public networks.**

## Quick Start

### Prerequisites
- Raspberry Pi 4 (or any Linux system for testing)
- Python 3.7+
- Network isolation (important!)
- Basic networking tools (nmap, curl, etc.)

### Installation

1. **Clone or download the lab files**
```bash
# Create working directory
mkdir ~/iot_security_lab1
cd ~/iot_security_lab1
```

2. **Run automated setup**
```bash
chmod +x setup.sh
./setup.sh
```

Or manually:

```bash
# Install dependencies
pip3 install -r requirements.txt

# Initialize the application
python3 vulnerable_iot_app.py
```

3. **Access the application**
- Web Interface: `http://<device-ip>:5000`
- API Endpoint: `http://<device-ip>:5000/api/temperature`
- Admin Panel: `http://<device-ip>:5000/login`

## File Structure
```
iot_security_lab1/
├── vulnerable_iot_app.py      # Main application (with vulnerabilities)
├── templates/
│   ├── index.html             # Dashboard
│   └── login.html             # Login page
├── setup.sh                   # Automated setup script
├── requirements.txt           # Python dependencies
├── fake_sensor.py            # Simulated sensor data
├── backup.sh                 # Vulnerable backup script
├── config.ini                # Exposed configuration
├── network_scan.py           # Testing utility
├── LAB1_Student_Worksheet.md # Student assignment
└── LAB1_Instructor_Guide.md  # Teaching guide (INSTRUCTORS ONLY)
```

## Lab Objectives

### Primary Learning Goals
1. Identify common IoT security vulnerabilities
2. Understand the OWASP IoT Top 10
3. Practice exploitation techniques safely
4. Learn remediation strategies
5. Develop security assessment skills

### Skills Developed
- Reconnaissance and information gathering
- Web application security testing
- Network analysis
- Vulnerability assessment
- Security report writing
- Ethical hacking practices

## Vulnerabilities Included

This lab contains 16+ intentional vulnerabilities across multiple categories:

### Critical Severity
- Hardcoded credentials
- SQL injection
- Command injection
- Authentication bypass

### High Severity  
- Sensitive data exposure
- Missing authentication
- Insecure direct object references
- Weak session management

### Medium/Low Severity
- Information disclosure
- CORS misconfiguration
- Debug mode enabled
- Insecure cookies
- Client-side validation only

## Student Instructions

### Phase 1: Setup (15 min)
1. Deploy the application on your assigned Raspberry Pi
2. Verify network connectivity
3. Access the web interface
4. Review the student worksheet

### Phase 2: Reconnaissance (20 min)
- Explore without credentials
- Check source code and comments
- Use developer tools
- Document findings

### Phase 3: Vulnerability Assessment (45 min)
- Work through the vulnerability checklist
- Document each finding with:
  - Location
  - Method of discovery
  - Potential impact
  - Proof of concept

### Phase 4: Exploitation (30 min)
Complete the three main challenges:
1. Gain administrative access (3 methods)
2. Extract sensitive data
3. Achieve remote code execution

### Phase 5: Reporting (20 min)
- Complete vulnerability summary table
- Provide risk assessment
- Suggest remediation priorities

## Instructor Notes

### Pre-Lab Setup
1. Isolate lab network (CRITICAL)
2. Prepare one Pi per student/group
3. Test all components
4. Review instructor guide
5. Prepare demonstration system

### Time Management
- Total lab time: 2 hours
- Allow flexibility for different skill levels
- Have bonus challenges ready for advanced students
- Keep reset scripts handy

### Safety Briefing (MANDATORY)
Before starting, cover:
- Legal implications
- Ethical boundaries  
- Responsible disclosure
- Professional conduct
- Never test without permission

### Common Issues

**Application won't start:**
```bash
# Check port availability
sudo netstat -tulpn | grep 5000
# Kill existing process if needed
sudo pkill -f vulnerable_iot_app.py
```

**Can't find vulnerabilities:**
- Guide students to HTML comments
- Suggest checking browser console
- Hint at common default passwords

**SQL injection not working:**
- Check quote types (single vs double)
- Try different payloads
- URL encode if needed

## Ethical Guidelines

### Student Agreement Required
Before beginning this lab, all students must acknowledge:

1. These techniques are for educational purposes only
2. Never test on systems you don't own
3. Always obtain written permission
4. Report vulnerabilities responsibly
5. Respect privacy and confidentiality
6. Understand legal consequences of misuse

### Responsible Disclosure
If students find additional vulnerabilities:
1. Document thoroughly
2. Report to instructor
3. Don't exploit beyond lab requirements
4. Keep findings confidential

## Assessment Rubric

| Component | Weight | Criteria |
|-----------|--------|----------|
| Vulnerabilities Found | 30% | Number and severity of findings |
| Exploitation Success | 20% | Successful demonstration of exploits |
| Documentation Quality | 20% | Clear, professional reporting |
| Remediation Planning | 15% | Practical, prioritized fixes |
| Presentation | 10% | Clear communication of findings |
| Bonus Discoveries | 5% | Additional vulnerabilities or creative exploits |

## Extensions & Advanced Challenges

### For Advanced Students
1. Automate vulnerability scanning
2. Create Metasploit module
3. Implement persistent backdoor
4. Perform privilege escalation
5. Write proof-of-concept exploits

### Follow-Up Projects
1. Secure version - fix all vulnerabilities
2. Penetration testing competition
3. Incident response scenario
4. IoT forensics investigation

## Reset Between Groups

```bash
# Quick reset script
./reset_lab.sh

# Or manually:
pkill -f vulnerable_iot_app.py
rm -f iot_temp.db
rm -f /tmp/backup_*
python3 vulnerable_iot_app.py &
```

## Additional Resources

### References
- [OWASP IoT Top 10](https://owasp.org/www-project-internet-of-things/)
- [NIST IoT Cybersecurity](https://www.nist.gov/programs-projects/nist-cybersecurity-iot-program)
- [IoT Security Foundation](https://www.iotsecurityfoundation.org/)

### Tools Used
- nmap - Network scanning
- Burp Suite - Web proxy
- Wireshark - Packet analysis
- sqlmap - SQL injection
- John the Ripper - Password cracking

### Real-World Cases
- Mirai Botnet (2016)
- Ring Camera Hacks (2019)
- Casino Fish Tank Breach (2017)
- Jeep Cherokee Hack (2015)

## Support

### Troubleshooting
For common issues, check:
1. Network connectivity
2. Python version (3.7+)
3. Port availability
4. Firewall rules
5. File permissions

### Contact
- Instructor: [Your Name]
- Office Hours: [Time/Location]
- Emergency Contact: [IT Support]

## License & Disclaimer

This educational material is provided "as is" for teaching purposes only. The authors assume no liability for misuse or damage caused by these materials. Users are responsible for complying with all applicable laws and regulations.

---

**Remember:** With great power comes great responsibility. Use these skills ethically and legally to make the IoT ecosystem more secure for everyone.
