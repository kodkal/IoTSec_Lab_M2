#!/bin/bash

# Lab Reset Script - Complete Removal or Soft Reset
# Usage: ./reset_lab.sh [--soft]

echo "======================================="
echo "    IoT Security Lab Reset Script"
echo "======================================="

# Check for soft reset option
if [[ "$1" == "--soft" ]]; then
    # SOFT RESET - Clean but keep files
    echo "Mode: Soft Reset (keeping files)"
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
        echo "Default login: a... / 1..."
    else
        echo ""
        echo "❌ Error: Application failed to start!"
        echo "Check /tmp/iot_app.log for errors"
    fi
    
    echo ""
    echo "======================================="
    echo "Ready for next student!"
    echo "======================================="
    
else
    # COMPLETE REMOVAL - Delete everything
    echo "Mode: Complete Removal"
    echo "======================================="
    
    # Stop any running instances
    echo "[1/4] Stopping running applications..."
    pkill -f vulnerable_iot_app.py 2>/dev/null
    pkill -f fake_sensor.py 2>/dev/null
    sleep 2
    
    # Verify processes are stopped
    if pgrep -f vulnerable_iot_app.py > /dev/null; then
        echo "  ⚠️  Force killing stubborn processes..."
        pkill -9 -f vulnerable_iot_app.py 2>/dev/null
    fi
    
    # Get the current directory (where the lab is installed)
    LAB_DIR=$(pwd)
    LAB_NAME=$(basename "$LAB_DIR")
    
    # Clean up any created files and databases
    echo "[2/4] Cleaning up lab artifacts..."
    rm -f iot_temp.db 2>/dev/null
    rm -f /tmp/backup_*.tar.gz 2>/dev/null
    rm -f /tmp/*.log 2>/dev/null
    rm -rf logs/* 2>/dev/null
    rm -f *.pyc 2>/dev/null
    rm -rf __pycache__ 2>/dev/null
    
    # Confirm before deletion
    echo ""
    echo "⚠️  WARNING: This will COMPLETELY REMOVE the lab!"
    echo "   Directory to be deleted: $LAB_DIR"
    echo ""
    echo "Options:"
    echo "  1. Type 'yes' to completely remove the lab"
    echo "  2. Type 'soft' to just reset (keep files)"
    echo "  3. Press Enter to cancel"
    echo ""
    read -p "Your choice: " -r
    echo
    
    if [[ $REPLY == "yes" ]]; then
        # Move up one directory before deleting
        echo "[3/4] Preparing to remove lab directory..."
        cd ..
        
        echo "[4/4] Removing entire lab directory..."
        rm -rf "$LAB_DIR"
        
        echo ""
        echo "✅ Lab completely removed!"
        echo ""
        echo "======================================="
        echo "Lab has been completely uninstalled."
        echo "======================================="
        echo ""
        echo "To reinstall, run:"
        echo "  git clone https://github.com/kodkal/IoTSec_Lab_M2.git"
        echo "  cd IoTSec_Lab_M2"
        echo "  ./quickstart.sh"
        echo ""
    elif [[ $REPLY == "soft" ]]; then
        # Run soft reset instead
        echo "Switching to soft reset..."
        $0 --soft
    else
        echo "❌ Removal cancelled. Lab files remain intact."
        echo ""
        echo "To reset without removing files, run:"
        echo "  ./reset_lab.sh --soft"
    fi
fi
