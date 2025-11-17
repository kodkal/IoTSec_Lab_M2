#!/bin/bash

# Lab Reset Script
# Quickly reset the IoT Security Lab between student groups

echo "======================================="
echo "    IoT Security Lab Reset Script"
echo "======================================="

# Stop any running instances
echo "[1/6] Stopping running applications..."
pkill -f vulnerable_iot_app.py 2>/dev/null
pkill -f fake_sensor.py 2>/dev/null
sleep 2

# Clean up databases and temporary files
echo "[2/6] Cleaning databases and temp files..."
rm -f iot_temp.db
rm -f /tmp/backup_*.tar.gz
rm -f /tmp/*.log
rm -rf logs/*
rm -f *.pyc
rm -rf __pycache__

# Reset configuration files
echo "[3/6] Resetting configuration files..."
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

# Clear any student-created files
echo "[4/6] Cleaning student artifacts..."
rm -f exploit*.py 2>/dev/null
rm -f poc*.py 2>/dev/null
rm -f payload*.txt 2>/dev/null
rm -f extracted_*.txt 2>/dev/null

# Clear system logs that might contain student activity
echo "[5/6] Clearing system logs..."
> /var/log/auth.log 2>/dev/null
> /var/log/syslog 2>/dev/null
journalctl --rotate 2>/dev/null
journalctl --vacuum-time=1s 2>/dev/null

# Restart the application
echo "[6/6] Starting fresh application instance..."
cd $(dirname "$0")
python3 vulnerable_iot_app.py > /tmp/iot_app.log 2>&1 &

sleep 3

# Verify application is running
if pgrep -f vulnerable_iot_app.py > /dev/null; then
    echo ""
    echo "✅ Reset complete! Application running."
    echo ""
    APP_PID=$(pgrep -f vulnerable_iot_app.py)
    echo "Application PID: $APP_PID"
    echo "Application URL: http://$(hostname -I | awk '{print $1}'):5000"
    echo "Default login: admin / 123456"
else
    echo ""
    echo "❌ Error: Application failed to start!"
    echo "Check /tmp/iot_app.log for errors"
fi

echo ""
echo "======================================="
echo "Ready for next student group!"
echo "======================================="
echo ""
echo "Checklist for instructor:"
echo "  □ Clear browser cache on student machine"
echo "  □ Close any terminal sessions"
echo "  □ Reset network captures if running"
echo "  □ Verify isolated network"
echo "  □ Distribute fresh worksheet"
echo ""
