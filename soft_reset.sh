#!/bin/bash

# Lab Soft Reset Script
# Resets the lab to clean state without removing files

echo "======================================="
echo "    IoT Security Lab - Soft Reset"
echo "======================================="

# Stop any running instances
echo "[1/5] Stopping running applications..."
pkill -f vulnerable_iot_app.py 2>/dev/null
pkill -f fake_sensor.py 2>/dev/null
sleep 2

# Clean up databases and temporary files
echo "[2/5] Cleaning databases and temp files..."
rm -f iot_temp.db
rm -f /tmp/backup_*.tar.gz
rm -f /tmp/*.log
rm -rf logs/*
rm -f *.pyc
rm -rf __pycache__

# Clear any student-created files
echo "[3/5] Cleaning student artifacts..."
rm -f exploit*.py 2>/dev/null
rm -f poc*.py 2>/dev/null
rm -f payload*.txt 2>/dev/null
rm -f extracted_*.txt 2>/dev/null
rm -f test*.py 2>/dev/null

# Reset git repository to clean state
echo "[4/5] Resetting repository to clean state..."
git checkout -- . 2>/dev/null
git clean -fd 2>/dev/null

# Restart the application
echo "[5/5] Starting fresh application instance..."
python3 vulnerable_iot_app.py > /tmp/iot_app.log 2>&1 &

sleep 3

# Verify application is running
if pgrep -f vulnerable_iot_app.py > /dev/null; then
    echo ""
    echo "✅ Soft reset complete! Application running."
    echo ""
    APP_PID=$(pgrep -f vulnerable_iot_app.py)
    echo "Application PID: $APP_PID"
    echo "Application URL: http://$(hostname -I | awk '{print $1}'):5000"
    # echo "Default login: admin / 123456"
else
    echo ""
    echo "❌ Error: Application failed to start!"
    echo "Check /tmp/iot_app.log for errors"
fi

echo ""
echo "======================================="
echo "Ready for next student!"
echo "======================================="