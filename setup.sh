#!/bin/bash

# Vulnerable IoT Lab Setup Script
# For Educational Purposes Only

echo "========================================="
echo "IoT Security Lab 1: Vulnerable Smart Home"
echo "========================================="

# Update system
echo "[*] Updating system packages..."
sudo apt-get update

# Install Python and pip
echo "[*] Installing Python3 and pip..."
sudo apt-get install -y python3 python3-pip

# Install Flask and dependencies
echo "[*] Installing Flask and required libraries..."
pip3 install flask
pip3 install flask-cors

# Create necessary directories
echo "[*] Creating application directories..."
mkdir -p templates
mkdir -p static
mkdir -p logs

# Set up fake temperature sensor (for simulation)
echo "[*] Creating simulated sensor data..."
cat > fake_sensor.py << 'EOF'
#!/usr/bin/env python3
import random
import time
import json

def read_temperature():
    """Simulate temperature sensor reading"""
    return round(random.uniform(18.0, 28.0), 2)

def read_humidity():
    """Simulate humidity sensor reading"""
    return round(random.uniform(30.0, 70.0), 1)

if __name__ == "__main__":
    while True:
        data = {
            "temperature": read_temperature(),
            "humidity": read_humidity(),
            "timestamp": time.time()
        }
        print(json.dumps(data))
        time.sleep(5)
EOF

chmod +x fake_sensor.py

# Create a systemd service (optional)
echo "[*] Creating systemd service file..."
cat > iot_monitor.service << 'EOF'
[Unit]
Description=Vulnerable IoT Temperature Monitor
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/iot_lab
ExecStart=/usr/bin/python3 /home/pi/iot_lab/vulnerable_iot_app.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Create additional vulnerable scripts
echo "[*] Creating additional vulnerable components..."

# Vulnerable backup script
cat > backup.sh << 'EOF'
#!/bin/bash
# VULNERABILITY: Hardcoded credentials in script
MYSQL_USER="root"
MYSQL_PASS="toor"
tar -czf /tmp/backup_$(date +%Y%m%d).tar.gz /home/pi/iot_lab/
echo "Backup completed"
EOF
chmod +x backup.sh

# Vulnerable config file
cat > config.ini << 'EOF'
[database]
host = localhost
port = 3306
user = admin
password = 123456

[api]
key = AKIAIOSFODNN7EXAMPLE
secret = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[mqtt]
broker = 192.168.1.100
port = 1883
user = iot_device
pass = password

[wifi]
ssid = HomeNetwork
password = password123
EOF

# Create a vulnerable cron job
echo "[*] Setting up vulnerable cron job..."
echo "*/5 * * * * /home/pi/iot_lab/backup.sh > /tmp/backup.log 2>&1" > vulnerable_cron
echo "Note: To activate cron job, run: crontab vulnerable_cron"

# Create network scanner script (for testing)
cat > network_scan.py << 'EOF'
#!/usr/bin/env python3
import subprocess
import socket

def scan_ports(host, ports=[80, 5000, 22, 1883]):
    """Basic port scanner"""
    print(f"Scanning {host}...")
    for port in ports:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(1)
        result = sock.connect_ex((host, port))
        if result == 0:
            print(f"  Port {port}: OPEN")
        sock.close()

if __name__ == "__main__":
    scan_ports("localhost")
EOF
chmod +x network_scan.py

echo ""
echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""
echo "Your Raspberry Pi IP address is:"
echo "  $(hostname -I | awk '{print $1}')"
echo ""
echo "To start the vulnerable IoT application:"
echo "  python3 vulnerable_iot_app.py"
echo ""
echo "The application will be available at:"
echo "  http://$(hostname -I | awk '{print $1}'):5000"
echo ""
# echo "Default credentials:"
# echo "  Username: admin"
# echo "  Password: 123456"
echo ""
echo "To find your IP address later, run:"
echo "  hostname -I"
echo ""
echo "WARNING: This application is intentionally"
echo "vulnerable. Use only in isolated lab environment!"
echo "========================================="