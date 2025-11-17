# IoT Security Lab - Module 2: Challenges for Secure IoT

## Overview
Hands-on lab featuring an intentionally vulnerable IoT temperature monitoring system. Students will identify, exploit, and document security vulnerabilities in a controlled environment.

**⚠️ WARNING: This application contains intentional security vulnerabilities. FOR EDUCATIONAL PURPOSES ONLY.**

## Quick Start for Students

### 1️⃣ SSH into your Raspberry Pi
```bash
# From your Mac/PC:
ssh pi@raspberrypi.local
# Password: raspberry
```

### 2️⃣ Clone this repository (ON THE PI)
```bash
# You're now on the Pi (notice prompt changed to pi@raspberrypi)
cd ~
git clone https://github.com/kodkal/IoTSec_Lab_M2.git
cd IoTSec_Lab_M2
```

### 3️⃣ Run setup (ON THE PI)
```bash
# Still on the Pi:
chmod +x setup.sh
./setup.sh
```

### 4️⃣ Start the vulnerable app (ON THE PI)
```bash
# Still on the Pi:
python3 vulnerable_iot_app.py

# Note the IP address shown!
# Network: http://192.168.1.XXX:5000
```

### 5️⃣ Access from your browser (ON YOUR MAC/PC)
Open Chrome/Firefox on YOUR computer and go to:
```
http://[PI-IP]:5000
```

## Lab Contents

### Core Files
- `vulnerable_iot_app.py` - Main application with 16+ vulnerabilities
- `setup.sh` - Automated setup script
- `reset_lab.sh` - Reset between student groups
- `templates/` - Web interface templates

### Documentation
- `LAB1_Student_Worksheet.md` - Student instructions & exercises
- `LAB1_Instructor_Guide.md` - Solutions & teaching notes
- `QUICK_REFERENCE.md` - Command cheat sheet
- `NETWORK_DISCOVERY_GUIDE.md` - How to find your Pi's IP

### If Using Package Version
- `IoT_Security_Lab1.tar.gz` - Complete packaged lab
  ```bash
  tar -xzf IoT_Security_Lab1.tar.gz
  cd IoT_Security_Lab1_Package
  ```

## Vulnerabilities to Find

### Critical (4)
- SQL Injection
- Command Injection
- Hardcoded Credentials
- Authentication Bypass

### High (4)
- Sensitive Data Exposure
- Missing Authentication
- Insecure Direct Object References
- Weak Session Management

### Medium/Low (8+)
- Information Disclosure
- CORS Misconfiguration
- Debug Mode Enabled
- Insecure Cookies
- And more...

## Default Credentials
- Username: `admin`
- Password: `123456`

## Key URLs
- Dashboard: `http://[pi-ip]:5000/`
- Login: `http://[pi-ip]:5000/login`
- API: `http://[pi-ip]:5000/api/temperature`
- Settings: `http://[pi-ip]:5000/api/settings`

## For Instructors

### Pre-Lab Setup
1. Ensure network isolation
2. Assign Pi's to students with IP list
3. Test with: `curl http://[pi-ip]:5000`

### Quick Reset Between Groups
```bash
ssh pi@[pi-ip]
cd ~/IoTSec_Lab_M2
./reset_lab.sh
```

### Monitoring Student Progress
```bash
# Watch for successful exploits:
tail -f /tmp/iot_app.log
```

## Troubleshooting

### Can't Clone Repository?
If the repo is private, your instructor will provide access method.

### Can't Find Pi?
```bash
# On the Pi:
hostname -I
```

### Application Won't Start?
```bash
# Check Python version (needs 3.7+):
python3 --version

# Reinstall dependencies:
pip3 install flask flask-cors
```

### Port Already in Use?
```bash
# Kill existing process:
pkill -f vulnerable_iot_app.py

# Or use different port:
python3 vulnerable_iot_app.py --port 5001
```

## Assessment
Students will be graded on:
- Number of vulnerabilities found (30%)
- Successful exploitations (20%)
- Documentation quality (20%)
- Remediation recommendations (15%)
- Presentation (10%)
- Bonus discoveries (5%)

## Ethical Guidelines
By participating in this lab, you agree to:
- Only test on assigned systems
- Not attack production systems
- Report vulnerabilities responsibly
- Respect privacy and confidentiality
- Use knowledge ethically

## Support
- Instructor: [Name]
- Lab Time: [Schedule]
- Office Hours: [Time/Location]

## License
Educational use only. Do not deploy in production environments.

---

**Remember:** The Raspberry Pi runs the vulnerable server. Your laptop/PC is the attacker. Keep the app running on the Pi while you test from your computer!