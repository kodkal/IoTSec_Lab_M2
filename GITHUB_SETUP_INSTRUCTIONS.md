# IoT Security Lab Setup - GitHub Version

## Quick Start Guide for Students

### Step 1: Connect to Your Raspberry Pi
From your Mac/PC terminal, SSH into your assigned Raspberry Pi:
```bash
# From your Mac/PC terminal:
ssh pi@raspberrypi.local
# OR use the IP address provided by your instructor:
ssh pi@192.168.1.XXX

# Default password: raspberry
```

### Step 2: Clone the Lab from GitHub (ON THE RASPBERRY PI)
Once you're connected to the Pi (you'll see `pi@raspberrypi:~ $`), run these commands:

```bash
# ON THE RASPBERRY PI - Clone the repository
cd ~
git clone https://github.com/kodkal/IoTSec_Lab_M2.git
cd IoTSec_Lab_M2

# If you need to extract the tar file (if using the packaged version):
tar -xzf IoT_Security_Lab1.tar.gz
cd IoT_Security_Lab1_Package

# OR if files are directly in the repo (not in tar):
# Stay in IoTSec_Lab_M2 directory
```

### Step 3: Run Setup Script (ON THE RASPBERRY PI)
```bash
# ON THE RASPBERRY PI - Make scripts executable and run setup
chmod +x setup.sh reset_lab.sh
./setup.sh

# This will install required Python packages and configure the environment
```

### Step 4: Start the Vulnerable Application (ON THE RASPBERRY PI)
```bash
# ON THE RASPBERRY PI - Start the vulnerable IoT application
python3 vulnerable_iot_app.py

# The application will display:
# ================================================
# 🌡️  Vulnerable IoT Temperature Monitor Starting...
# ================================================
# Access the application at:
#   Local: http://localhost:5000
#   Network: http://192.168.1.105:5000  <-- Note this IP!
# ================================================
```

**IMPORTANT:** Keep this terminal window open! The app needs to stay running.

### Step 5: Access the Application (FROM YOUR MAC/PC)
Open a web browser on YOUR laptop/computer and navigate to:
```
http://[PI-IP-ADDRESS]:5000
```
Example: `http://192.168.1.105:5000`

---

## Terminal Window Setup

For the best experience, you'll want multiple terminal windows:

### Terminal 1: SSH Session - Application Running
```bash
# From Mac/PC:
ssh pi@192.168.1.105

# On Pi:
cd ~/IoTSec_Lab_M2
python3 vulnerable_iot_app.py
# [KEEP THIS RUNNING]
```

### Terminal 2: SSH Session - Monitoring (Optional)
```bash
# From Mac/PC (new terminal):
ssh pi@192.168.1.105

# On Pi:
cd ~/IoTSec_Lab_M2
tail -f /tmp/iot_app.log
```

### Terminal 3: Mac/PC - Security Testing
```bash
# From Mac/PC (stay on your computer, don't SSH):
# Run your security tests from here
nmap -p 5000 192.168.1.105
curl http://192.168.1.105:5000/api/temperature
```

---

## Quick Command Reference

### Finding Your Pi's IP (ON THE PI)
```bash
# After SSH'ing into the Pi:
hostname -I | awk '{print $1}'
```

### Updating the Lab (ON THE PI)
```bash
# If the instructor updates the lab:
cd ~/IoTSec_Lab_M2
git pull
./setup.sh
```

### Resetting the Lab (ON THE PI)
```bash
# To reset for a fresh start:
cd ~/IoTSec_Lab_M2
./reset_lab.sh
```

### Stopping the Application (ON THE PI)
```bash
# In the terminal running the app:
Ctrl + C

# Or from another SSH session:
pkill -f vulnerable_iot_app.py
```

---

## Troubleshooting

### "Permission denied" for repository
```bash
# The repo might be private. Options:
# 1. Your instructor may provide credentials
# 2. Use the provided tar.gz file instead
# 3. Download via the method your instructor specifies
```

### "git: command not found"
```bash
# Install git on the Pi:
sudo apt-get update
sudo apt-get install git -y
```

### Can't connect to the application
```bash
# On the Pi, check if app is running:
ps aux | grep vulnerable_iot_app
netstat -tln | grep 5000

# From your Mac/PC, test connection:
ping [pi-ip]
curl http://[pi-ip]:5000
```

### Application crashes immediately
```bash
# Check for missing dependencies:
pip3 install flask flask-cors

# Check for port conflicts:
sudo netstat -tulpn | grep 5000
```

---

## Summary - Where Everything Runs

| Action | Where | Command |
|--------|-------|---------|
| Clone repository | Raspberry Pi (via SSH) | `git clone https://github.com/kodkal/IoTSec_Lab_M2.git` |
| Run setup | Raspberry Pi (via SSH) | `./setup.sh` |
| Start app | Raspberry Pi (via SSH) | `python3 vulnerable_iot_app.py` |
| Access website | Your Mac/PC Browser | Navigate to `http://[pi-ip]:5000` |
| Run attacks | Your Mac/PC Terminal | `nmap`, `curl`, `sqlmap`, etc. |

Remember: Pi = Server, Mac/PC = Client