# Lab Setup Workflow - Where to Run What

## Visual Overview

```
┌─────────────────┐                    ┌──────────────────┐
│   Your Mac/PC   │                    │  Raspberry Pi    │
│                 │                    │                  │
│  Terminal       │───SSH Connection──▶│  Terminal        │
│  Browser        │                    │  Python App      │
│  Attack Tools   │                    │  Web Server      │
└─────────────────┘                    └──────────────────┘
        ↑                                      ↓
        │                                      │
        └──────── HTTP (Port 5000) ───────────┘
```

## Step-by-Step Guide

### 🖥️ PART 1: From Your Mac/PC

#### Initial Connection
```bash
# Open Terminal on your Mac
# Connect to the Raspberry Pi via SSH
ssh pi@raspberrypi.local
# OR if you know the IP already:
ssh pi@192.168.1.105

# Default password: raspberry
```

---

### 🥧 PART 2: On the Raspberry Pi (via SSH or Direct)

#### Setup and Run Application
```bash
# You are now in the Pi's terminal (notice the prompt change)
pi@raspberrypi:~ $ 

# 1. Create working directory
mkdir ~/iot_security_lab1
cd ~/iot_security_lab1

# 2. Get the lab files (instructor will provide method)
# git clone https://github.com/kodkal/IoTSec_Lab_M2.git

# 3. Extract lab files
tar -xzf IoT_Security_Lab1.tar.gz
cd IoT_Security_Lab1_Package

# 4. Run setup
chmod +x setup.sh
./setup.sh

# 5. Start the vulnerable application
python3 vulnerable_iot_app.py

# 6. Note the IP address displayed:
# ================================================
# Access the application at:
#   Network: http://192.168.1.105:5000  <-- Use this
# ================================================
```

#### Leave Application Running
- Keep this terminal window open
- The application must stay running
- To stop later: Press `Ctrl+C`

---

### 🖥️ PART 3: Back on Your Mac/PC

#### Open New Terminal Window (Cmd+N or Ctrl+Shift+N)
```bash
# Test connection to the Pi
ping 192.168.1.105

# Test the web application
curl http://192.168.1.105:5000
```

#### Open Web Browser
1. Open Chrome/Firefox/Safari on YOUR Mac/PC
2. Navigate to: `http://192.168.1.105:5000`
3. You should see the IoT Temperature Monitor page

#### Run Security Tests (from Mac/PC)
```bash
# These commands run from YOUR computer, targeting the Pi

# Port scan
nmap -p 5000 192.168.1.105

# Test for vulnerabilities
curl -X POST http://192.168.1.105:5000/api/command \
  -H "Content-Type: application/json" \
  -d '{"command":"id"}'

# SQL injection test
curl -X POST http://192.168.1.105:5000/login \
  -d "username=admin' OR '1'='1&password=test"
```

---

## Quick Reference Table

| Task | Where to Run | Command Example |
|------|--------------|-----------------|
| SSH to Pi | Mac/PC Terminal | `ssh pi@raspberrypi.local` |
| Install lab files | Raspberry Pi | `tar -xzf IoT_Security_Lab1.tar.gz` |
| Run setup script | Raspberry Pi | `./setup.sh` |
| Start application | Raspberry Pi | `python3 vulnerable_iot_app.py` |
| Find Pi's IP | Raspberry Pi | `hostname -I` |
| Access web interface | Mac/PC Browser | Navigate to `http://[pi-ip]:5000` |
| Run security scans | Mac/PC Terminal | `nmap -p 5000 [pi-ip]` |
| Test vulnerabilities | Mac/PC Terminal | `curl http://[pi-ip]:5000/api/...` |
| Use Burp Suite | Mac/PC | Configure proxy to intercept Pi traffic |
| View application logs | Raspberry Pi | Check terminal where app is running |
| Stop application | Raspberry Pi | Press `Ctrl+C` in app terminal |
| Restart application | Raspberry Pi | `python3 vulnerable_iot_app.py` |

---

## Common Confusion Points Clarified

### ❌ DON'T Do This:
```bash
# On your Mac - This WON'T work:
mac-user@MacBook $ python3 vulnerable_iot_app.py  # ❌ Wrong!
mac-user@MacBook $ ./setup.sh                     # ❌ Wrong!
```

### ✅ DO This Instead:
```bash
# First SSH to Pi, THEN run commands:
mac-user@MacBook $ ssh pi@raspberrypi.local       # ✅ Correct
pi@raspberrypi $ python3 vulnerable_iot_app.py    # ✅ Correct
```

---

## Multiple Terminal Windows Setup

For the best experience, you'll want multiple terminal windows:

### Terminal Window 1 (SSH to Pi - App Running)
```
pi@raspberrypi:~/iot_security_lab1 $ python3 vulnerable_iot_app.py
* Running on http://0.0.0.0:5000
* Debug mode: on
[Leave this running]
```

### Terminal Window 2 (SSH to Pi - Monitoring)
```
pi@raspberrypi:~ $ tail -f /tmp/iot_app.log
pi@raspberrypi:~ $ netstat -tln | grep 5000
[Use for monitoring/debugging]
```

### Terminal Window 3 (Your Mac - Attack Tools)
```
mac-user@MacBook $ nmap -sV 192.168.1.105
mac-user@MacBook $ sqlmap -u "http://192.168.1.105:5000/login"
[Run your security tools here]
```

### Browser Window (Your Mac)
```
http://192.168.1.105:5000
[Interact with the vulnerable application]
```

---

## Troubleshooting Connection Issues

### Can't SSH to Pi?
```bash
# From Mac, try:
ssh pi@raspberrypi.local
ssh pi@raspberrypi
ssh pi@[ip-address]

# If still failing:
# 1. Check you're on same network
# 2. Check Pi is powered on
# 3. Ask instructor for IP/credentials
```

### Application Not Accessible from Browser?
```bash
# On the Pi, check if app is running:
ps aux | grep vulnerable_iot_app
netstat -tln | grep 5000

# From Mac, check connectivity:
ping [pi-ip]
nc -zv [pi-ip] 5000
```

### "Connection Refused" Error?
- Make sure application is still running on Pi
- Check firewall settings
- Verify correct IP address
- Ensure you're on same network/VLAN
