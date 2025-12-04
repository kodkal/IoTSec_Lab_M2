#!/bin/bash

# Quick Start Script for IoT Security Lab
# Run this immediately after cloning the repository

echo "================================================"
echo "   IoT Security Lab - Quick Start Setup"
echo "================================================"
echo ""

# Check if we're on a Raspberry Pi
if [ ! -f /proc/device-tree/model ] || ! grep -q "Raspberry Pi" /proc/device-tree/model 2>/dev/null; then
    echo "⚠️  Warning: This doesn't appear to be a Raspberry Pi."
    echo "   The lab is designed for Raspberry Pi but may work on other Linux systems."
    echo -n "   Continue anyway? (y/n): "
    read REPLY
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Display current location
echo "📍 Current directory: $(pwd)"
echo ""

# Check for required files
echo "Checking for lab files..."
if [ -f "vulnerable_iot_app.py" ]; then
    echo "✅ Main application found"
elif [ -f "IoT_Security_Lab1.tar.gz" ]; then
    echo "📦 Package found, extracting..."
    tar -xzf IoT_Security_Lab1.tar.gz
    cd IoT_Security_Lab1_Package
    echo "✅ Files extracted"
else
    echo "❌ Error: Lab files not found!"
    echo "   Make sure you're in the IoTSec_Lab_M2 directory"
    exit 1
fi

# Check for templates directory
if [ ! -d "templates" ]; then
    echo "❌ Error: templates directory not found!"
    echo "   The repository may be incomplete."
    exit 1
fi

# Make scripts executable
echo ""
echo "Setting up permissions..."
chmod +x setup.sh reset_lab.sh 2>/dev/null
echo "✅ Scripts are executable"

# Check Python installation
echo ""
echo "Checking Python installation..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    echo "✅ Python $PYTHON_VERSION found"
else
    echo "❌ Python 3 not found. Installing..."
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
fi

# Install dependencies
echo ""
echo "Installing Python packages..."
pip3 install flask flask-cors 2>/dev/null || pip3 install flask flask-cors --break-system-packages 2>/dev/null
echo "✅ Dependencies installed"

# Get IP address
echo ""
echo "================================================"
echo "   Network Information"
echo "================================================"
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo "🌐 Your Raspberry Pi IP address: $IP_ADDRESS"
echo ""

# Create startup command
echo "================================================"
echo "   Ready to Start!"
echo "================================================"
echo ""
echo "To start the vulnerable IoT application, run:"
echo ""
echo "  python3 vulnerable_iot_app.py"
echo ""
echo "Then access it from your computer's browser at:"
echo ""
echo "  http://$IP_ADDRESS:5000"
echo ""
echo "Default login credentials:"
echo "  Username: a...."
echo "  Password: 1....."
echo ""
echo "================================================"
echo ""

# Ask if they want to start now
echo -n "Start the application now? (y/n): "
read REPLY
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Starting application..."
    echo "Press Ctrl+C to stop"
    echo ""
    python3 vulnerable_iot_app.py
fi
