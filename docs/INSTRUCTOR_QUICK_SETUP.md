# Instructor's Quick Setup Guide

## Pre-Class Preparation

### On Each Raspberry Pi:
```bash
# 1. Copy lab files to each Pi (via USB or network)
# 2. Extract on each Pi:
tar -xzf IoT_Security_Lab1.tar.gz
cd IoT_Security_Lab1_Package

# 3. Run setup (installs Python packages)
./setup.sh

# 4. Start the application
python3 vulnerable_iot_app.py &

# 5. Note each Pi's IP address
hostname -I
```

### Create Student Handout:
```
Pi #1: IP = 192.168.1.101  | SSH: pi@192.168.1.101 | Password: raspberry
Pi #2: IP = 192.168.1.102  | SSH: pi@192.168.1.102 | Password: raspberry
Pi #3: IP = 192.168.1.103  | SSH: pi@192.168.1.103 | Password: raspberry
...
```

## Quick Student Instructions

### Tell Students:
1. **FROM YOUR MAC/PC**: SSH to your assigned Pi
   ```bash
   ssh pi@192.168.1.101
   ```

2. **ON THE PI**: Start the vulnerable app
   ```bash
   cd iot_security_lab1/IoT_Security_Lab1_Package
   python3 vulnerable_iot_app.py
   ```

3. **FROM YOUR MAC/PC BROWSER**: Access the web interface
   ```
   http://192.168.1.101:5000
   ```

4. **FROM YOUR MAC/PC**: Run security tests
   ```bash
   nmap -p 5000 192.168.1.101
   curl http://192.168.1.101:5000/api/temperature
   ```

## Common Student Mistakes to Watch For:

❌ **Trying to run Python app on their Mac**
✅ Remind: "The app runs ON the Pi, you ACCESS it from your Mac"

❌ **Closing SSH terminal after starting app**
✅ Remind: "Keep the SSH window open with app running"

❌ **Typing Pi commands in Mac terminal**
✅ Check their prompt: `mac$` vs `pi@raspberrypi$`

## Quick Fixes:

**"Can't connect to Pi"**
- Check network connection
- Verify correct IP
- Try raspberrypi.local

**"Web page won't load"**
- Check app is running on Pi
- Verify port 5000 is open
- Check firewall settings

**"Command not found"**
- They're probably on wrong machine
- Check which terminal they're in