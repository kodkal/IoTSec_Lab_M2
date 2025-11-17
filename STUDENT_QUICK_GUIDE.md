# IoT Security Lab - Student Quick Guide

## Your Mission
Find and exploit security vulnerabilities in a smart home IoT device.

## Setup Steps (5 minutes)

### 1. Connect to Your Raspberry Pi
```bash
# From YOUR computer:
ssh pi@192.168.1.[YOUR-PI-NUMBER]
password: raspberry
```

### 2. Get the Lab Code
```bash
# Now you're ON THE PI (see pi@raspberrypi):
cd ~
git clone https://github.com/kodkal/IoTSec_Lab_M2.git
cd IoTSec_Lab_M2
```

### 3. Quick Setup
```bash
# Still ON THE PI:
chmod +x quickstart.sh
./quickstart.sh
# Type 'y' when prompted
```

### 4. Note Your IP
The script will show: `Your Raspberry Pi IP address: 192.168.1.XXX`
**Write it down:** _______________

### 5. Access the App
**On YOUR computer** (not the Pi):
- Open Chrome/Firefox
- Go to: `http://[YOUR-PI-IP]:5000`
- You should see the IoT Temperature Monitor

## Quick Test Commands

### From YOUR Computer (Not SSH)
```bash
# Test connection:
curl http://[YOUR-PI-IP]:5000

# View API:
curl http://[YOUR-PI-IP]:5000/api/temperature

# Quick scan:
nmap -p 5000 [YOUR-PI-IP]
```

## Start Hunting!

### Easy Wins to Try First:
1. **View Page Source** - Check HTML comments
2. **Try Default Login** - admin/123456
3. **Check Browser Console** - Press F12
4. **Look at /api/settings** - Exposed data?
5. **Test Command Injection** - In the command box

### SQL Injection Test:
Username: `admin' OR '1'='1`
Password: `anything`

### Command Injection Test:
In command box: `; cat /etc/passwd`

## Troubleshooting

**Can't connect?**
- Is the app still running on Pi?
- Check IP is correct
- Are you on same network?

**App crashed?**
```bash
# SSH to Pi and restart:
cd ~/IoTSec_Lab_M2
python3 vulnerable_iot_app.py
```

## Remember
- 🥧 Pi = Server (runs the app)
- 💻 Your laptop = Attacker
- 📝 Document everything you find!
- ⚠️ Only attack YOUR assigned Pi

---
**Need help?** Check `QUICK_REFERENCE.md` for more commands