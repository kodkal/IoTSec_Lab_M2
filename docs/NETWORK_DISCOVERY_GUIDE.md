# Finding Your Raspberry Pi on the Network

## Quick Guide for Students

### Method 1: Direct Connection (If you have physical/SSH access)
If you're already connected to your Pi, run one of these commands:
```bash
# Simplest method - shows just the IP
hostname -I | awk '{print $1}'

# Alternative methods
ip addr show | grep "inet "
ifconfig eth0 | grep "inet "
ifconfig wlan0 | grep "inet "  # For WiFi
```

### Method 2: From the Instructor's Assignment
Your instructor may have assigned specific Raspberry Pis with labeled IP addresses:
- Look for a label on your Pi
- Check the assignment sheet
- Ask your instructor for your assigned Pi's IP

### Method 3: Network Scanning (From your laptop/computer)
Find all Raspberry Pis on your network:

#### Windows (PowerShell):
```powershell
# Find your network range first
ipconfig

# Then scan for Pis (using nmap if installed)
nmap -sn 192.168.1.0/24 | findstr "raspberry"

# Or use arp to find all devices
arp -a
```

#### macOS/Linux:
```bash
# Find your network range
ip route | grep default
# or
netstat -nr | grep default

# Scan for all Raspberry Pis
nmap -sn 192.168.1.0/24 | grep -B 2 "Raspberry"

# Alternative: Look for port 5000 (our app)
nmap -p 5000 192.168.1.0/24 --open

# Using arp-scan (if installed)
sudo arp-scan --local | grep -i raspberry
```

### Method 4: Router/DHCP Server
1. Log into your router's admin panel (usually 192.168.1.1 or 192.168.0.1)
2. Look for "DHCP Clients", "Connected Devices", or "Device List"
3. Find devices named "raspberrypi" or with Raspberry Pi MAC addresses (start with B8:27:EB or DC:A6:32)

### Method 5: mDNS/Bonjour (if enabled)
Try accessing your Pi using its hostname:
```bash
# Default hostname
ping raspberrypi.local

# Or if renamed
ping <hostname>.local

# Browse for services
avahi-browse -all  # Linux
dns-sd -B _http._tcp  # macOS
```

### Method 6: Using the Application Output
When you start the vulnerable IoT app, it displays the IP:
```bash
python3 vulnerable_iot_app.py
# Look for the line: "Network: http://192.168.1.105:5000"
```

### Common IP Ranges
Your Raspberry Pi will likely have an IP in one of these ranges:
- **Home networks**: 192.168.1.x or 192.168.0.x
- **Lab networks**: 10.0.0.x or 172.16.x.x
- **University networks**: Various, ask your instructor

### Troubleshooting

#### Can't find your Pi?
1. **Check physical connection**: Is ethernet cable connected? WiFi configured?
2. **Check if Pi is powered on**: Green LED should be on
3. **Verify network**: Is your computer on the same network/VLAN?
4. **Check firewall**: Lab network might isolate devices

#### Found IP but can't connect?
1. **Verify application is running**:
   ```bash
   # SSH to Pi first, then:
   ps aux | grep vulnerable_iot_app
   netstat -tln | grep 5000
   ```
2. **Check firewall on Pi**:
   ```bash
   sudo ufw status
   ```
3. **Try curl from Pi itself**:
   ```bash
   curl http://localhost:5000
   ```

### Quick Test
Once you think you have the IP, test it:
```bash
# Ping test
ping 192.168.1.105

# Port test
nc -zv 192.168.1.105 5000

# Web test
curl http://192.168.1.105:5000
```

### Tips for Instructors

#### Pre-Lab Setup:
1. Create a spreadsheet mapping Pi hostnames to IPs
2. Use DHCP reservations for consistent IPs
3. Label each Pi with its IP address
4. Consider using a Pi management tool like PiServer

#### Network Configuration Options:
```bash
# Set static IP on each Pi
sudo nano /etc/dhcpcd.conf
# Add:
interface eth0
static ip_address=192.168.1.100/24
static routers=192.168.1.1
static domain_name_servers=8.8.8.8

# Or use DHCP reservation on router/server
```

#### Batch Discovery Script:
```bash
#!/bin/bash
# Find all Pis with the vulnerable app running
echo "Scanning for IoT Lab Devices..."
for ip in 192.168.1.{1..254}; do
  if timeout 0.2 nc -z $ip 5000 2>/dev/null; then
    echo "Found lab device at: $ip"
  fi
done
```

---

## Remember
If you're still having trouble finding your Pi:
1. Ask your lab partner
2. Check with the instructor
3. Verify you're on the correct network/VLAN
4. Make sure the Pi is powered on and connected