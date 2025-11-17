#!/usr/bin/env python3
"""
Vulnerable IoT Temperature Monitor
WARNING: This application contains intentional security vulnerabilities
FOR EDUCATIONAL PURPOSES ONLY - DO NOT USE IN PRODUCTION
"""

from flask import Flask, render_template, request, jsonify, make_response
import sqlite3
import os
import random
import time
import subprocess
from datetime import datetime
import hashlib

app = Flask(__name__)

# VULNERABILITY #1: Hardcoded credentials
ADMIN_USERNAME = "admin"
ADMIN_PASSWORD = "123456"

# VULNERABILITY #2: Weak secret key
app.secret_key = "secret123"

# VULNERABILITY #3: Debug mode enabled
app.debug = True

# Initialize database with no encryption
def init_db():
    conn = sqlite3.connect('iot_temp.db')
    c = conn.cursor()
    # VULNERABILITY #4: Sensitive data stored in plaintext
    c.execute('''CREATE TABLE IF NOT EXISTS temperatures
                 (id INTEGER PRIMARY KEY, temp REAL, timestamp TEXT)''')
    c.execute('''CREATE TABLE IF NOT EXISTS users
                 (id INTEGER PRIMARY KEY, username TEXT, password TEXT)''')
    c.execute('''CREATE TABLE IF NOT EXISTS settings
                 (id INTEGER PRIMARY KEY, api_key TEXT, device_id TEXT)''')
    
    # Insert default admin user (plaintext password)
    c.execute("INSERT OR IGNORE INTO users (id, username, password) VALUES (1, ?, ?)",
              (ADMIN_USERNAME, ADMIN_PASSWORD))
    
    # VULNERABILITY #5: Exposed API key
    c.execute("INSERT OR IGNORE INTO settings (id, api_key, device_id) VALUES (1, ?, ?)",
              ("AKIAIOSFODNN7EXAMPLE", "DEVICE_001"))
    
    conn.commit()
    conn.close()

# Simulate temperature reading
def get_temperature():
    return round(random.uniform(18.0, 28.0), 2)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        # VULNERABILITY #6: SQL Injection
        conn = sqlite3.connect('iot_temp.db')
        c = conn.cursor()
        query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
        c.execute(query)
        user = c.fetchone()
        conn.close()
        
        if user:
            # VULNERABILITY #7: Session token predictable
            token = hashlib.md5(username.encode()).hexdigest()
            resp = make_response(jsonify({'status': 'success', 'token': token}))
            # VULNERABILITY #8: No secure flag on cookie
            resp.set_cookie('auth_token', token, httponly=False)
            return resp
        else:
            return jsonify({'status': 'failed'}), 401
    
    return render_template('login.html')

@app.route('/api/temperature')
def api_temperature():
    # VULNERABILITY #9: No authentication required for API
    temp = get_temperature()
    timestamp = datetime.now().isoformat()
    
    conn = sqlite3.connect('iot_temp.db')
    c = conn.cursor()
    c.execute("INSERT INTO temperatures (temp, timestamp) VALUES (?, ?)",
              (temp, timestamp))
    conn.commit()
    conn.close()
    
    # VULNERABILITY #10: Verbose error messages
    return jsonify({
        'temperature': temp,
        'timestamp': timestamp,
        'device_id': 'DEVICE_001',
        'firmware': 'v1.0.0',
        'debug_info': {
            'memory': os.popen('free -m').read(),
            'processes': os.popen('ps aux | head -5').read()
        }
    })

@app.route('/api/command', methods=['POST'])
def execute_command():
    # VULNERABILITY #11: Command injection
    cmd = request.json.get('command')
    if cmd:
        try:
            # Directly execute user input
            result = subprocess.check_output(cmd, shell=True, text=True)
            return jsonify({'output': result})
        except Exception as e:
            return jsonify({'error': str(e)})
    return jsonify({'error': 'No command provided'})

@app.route('/api/settings')
def get_settings():
    # VULNERABILITY #12: Information disclosure
    conn = sqlite3.connect('iot_temp.db')
    c = conn.cursor()
    c.execute("SELECT * FROM settings")
    settings = c.fetchone()
    conn.close()
    
    return jsonify({
        'api_key': settings[1],
        'device_id': settings[2],
        'wifi_ssid': 'HomeNetwork',
        'wifi_password': 'password123',
        'mqtt_broker': '192.168.1.100',
        'mqtt_port': 1883
    })

@app.route('/firmware')
def firmware():
    # VULNERABILITY #13: Directory traversal
    filename = request.args.get('file', 'firmware.bin')
    try:
        with open(f"/tmp/{filename}", 'r') as f:
            return f.read()
    except:
        return "File not found", 404

@app.route('/logs')
def logs():
    # VULNERABILITY #14: No access control
    return """
    System Logs:
    [2024-01-01 10:00:00] User admin logged in from 192.168.1.50
    [2024-01-01 10:05:00] Temperature reading: 22.5°C
    [2024-01-01 10:10:00] API key accessed: AKIAIOSFODNN7EXAMPLE
    [2024-01-01 10:15:00] SSH: root login attempted
    [2024-01-01 10:20:00] Backup created at /backup/config.tar.gz
    """

# VULNERABILITY #15: CORS misconfiguration
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', '*')
    response.headers.add('Access-Control-Allow-Methods', '*')
    return response

if __name__ == '__main__':
    init_db()
    
    # Display startup information
    import socket
    hostname = socket.gethostname()
    try:
        # Get IP address
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip_address = s.getsockname()[0]
        s.close()
    except:
        ip_address = "127.0.0.1"
    
    print("\n" + "="*50)
    print("🌡️  Vulnerable IoT Temperature Monitor Starting...")
    print("="*50)
    print(f"Access the application at:")
    print(f"  Local: http://localhost:5000")
    print(f"  Network: http://{ip_address}:5000")
    print(f"\nDefault credentials:")
    print(f"  Username: admin")
    print(f"  Password: 123456")
    print("\n⚠️  WARNING: This application is intentionally vulnerable!")
    print("="*50 + "\n")
    
    # VULNERABILITY #16: Exposed on all interfaces
    app.run(host='0.0.0.0', port=5000, debug=True)