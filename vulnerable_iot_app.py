#!/usr/bin/env python3
"""
Vulnerable IoT Temperature Monitor - Version 2
Now with settings protected behind authentication (but still vulnerable!)
"""

from flask import Flask, render_template, request, jsonify, make_response, redirect, url_for
import sqlite3
import os
import random
import time
import subprocess
from datetime import datetime
import hashlib
from functools import wraps

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

# Weak authentication check
def check_auth(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        auth_token = request.cookies.get('auth_token')
        
        # VULNERABILITY: Weak token validation
        if not auth_token:
            return jsonify({'error': 'Authentication required. Please login first.', 
                          'hint': 'Try /login with default credentials or SQL injection'}), 401
        
        # VULNERABILITY: Token can be forged (just MD5 of username)
        # Any MD5 hash is accepted as valid!
        if len(auth_token) == 32:  # MD5 hash length
            return f(*args, **kwargs)
        else:
            return jsonify({'error': 'Invalid token'}), 401
            
    return decorated_function

# Simulate temperature reading
def get_temperature():
    return round(random.uniform(18.0, 28.0), 2)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username', '')
        password = request.form.get('password', '')
        
        # VULNERABILITY #6: SQL Injection
        conn = sqlite3.connect('iot_temp.db')
        c = conn.cursor()
        
        # Build the vulnerable query - using f-string for SQL injection vulnerability
        query = f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
        
        # Debug output (visible in terminal where app is running)
        print(f"\n[DEBUG] Login attempt:")
        print(f"  Username: {username}")
        print(f"  Password: {password}")
        print(f"  SQL Query: {query}")
        
        try:
            # Execute the vulnerable query directly
            c.execute(query)
            user = c.fetchone()
            conn.close()
            
            print(f"  Query Result: {user}")
            
            if user:
                # Login successful (either legitimate or via SQL injection)
                # VULNERABILITY #7: Predictable token
                token = hashlib.md5(str(user[1]).encode()).hexdigest()
                resp = make_response(jsonify({
                    'status': 'success', 
                    'token': token,
                    'message': f'Logged in as {user[1]}',
                    'hint': 'Now you can access /api/settings!'
                }))
                # VULNERABILITY #8: No secure flag on cookie
                resp.set_cookie('auth_token', token, httponly=False)
                print(f"  ✅ Login successful for user: {user[1]}")
                return resp
            else:
                print(f"  ❌ Login failed - no matching user")
                return jsonify({'status': 'failed', 'message': 'Invalid credentials'}), 401
                
        except sqlite3.Error as e:
            # SQL error occurred (might be due to injection attempt)
            print(f"  ⚠️ SQL Error: {e}")
            conn.close()
            return jsonify({
                'status': 'failed', 
                'message': f'Database error: {str(e)}',
                'query': query  # VULNERABILITY: Shows the query
            }), 401
    
    return render_template('login.html')

@app.route('/api/temperature')
def api_temperature():
    # This endpoint remains public for realism
    temp = get_temperature()
    timestamp = datetime.now().isoformat()
    
    conn = sqlite3.connect('iot_temp.db')
    c = conn.cursor()
    c.execute("INSERT INTO temperatures (temp, timestamp) VALUES (?, ?)",
              (temp, timestamp))
    conn.commit()
    conn.close()
    
    return jsonify({
        'temperature': temp,
        'timestamp': timestamp,
        'device_id': 'DEVICE_001',
        'firmware': 'v1.0.0'
    })

@app.route('/api/settings')
@check_auth  # NOW REQUIRES AUTHENTICATION!
def get_settings():
    # VULNERABILITY #12: Information disclosure (but now behind auth)
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
        'mqtt_port': 1883,
        'ssh_password': 'raspberry',  # Extra sensitive data as reward
        'root_password': 'toor',
        'message': 'Good job! You found the protected settings!'
    })

@app.route('/api/command', methods=['POST'])
@check_auth  # Command execution also requires auth now
def execute_command():
    # VULNERABILITY #11: Command injection (but behind auth)
    cmd = request.json.get('command')
    if cmd:
        try:
            # Directly execute user input
            result = subprocess.check_output(cmd, shell=True, text=True)
            return jsonify({'output': result})
        except Exception as e:
            return jsonify({'error': str(e)})
    return jsonify({'error': 'No command provided'})

@app.route('/firmware')
def firmware():
    # VULNERABILITY #13: Directory traversal (public for easier discovery)
    filename = request.args.get('file', 'firmware.bin')
    try:
        with open(f"/tmp/{filename}", 'r') as f:
            return f.read()
    except:
        return "File not found", 404

@app.route('/logs')
def logs():
    # Logs remain public but with hint about authentication
    return """
    System Logs (Public):
    [2024-01-01 10:00:00] Temperature reading: 22.5°C
    [2024-01-01 10:05:00] Temperature reading: 23.1°C
    [2024-01-01 10:10:00] User admin logged in from 192.168.1.50
    [2024-01-01 10:15:00] Accessed protected settings endpoint
    [2024-01-01 10:20:00] Note: /api/settings now requires authentication
    [2024-01-01 10:25:00] Hint: Use admin/1..... or SQL injection to login
    """

@app.route('/api/status')
def api_status():
    # Public endpoint that hints about authentication
    auth_token = request.cookies.get('auth_token')
    
    if auth_token:
        return jsonify({
            'status': 'authenticated',
            'message': 'You are logged in! Try accessing /api/settings now',
            'available_endpoints': ['/api/settings', '/api/command', '/api/temperature']
        })
    else:
        return jsonify({
            'status': 'unauthenticated', 
            'message': 'Some features require authentication',
            'public_endpoints': ['/api/temperature', '/logs', '/firmware'],
            'protected_endpoints': ['/api/settings (login required)', '/api/command (login required)'],
            'hint': 'Try /login first'
        })

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
    print("🌡️  Vulnerable IoT Temperature Monitor v2")
    print("="*50)
    print(f"Access the application at:")
    print(f"  Local: http://localhost:5000")
    print(f"  Network: http://{ip_address}:5000")
    print(f"\nDefault credentials:")
    print(f"  Username: admin")
    print(f"  Password: 123456")
    print(f"\n⚠️  NEW: Settings now require authentication!")
    print("="*50 + "\n")
    
    # VULNERABILITY #16: Exposed on all interfaces
    app.run(host='0.0.0.0', port=5000, debug=True)
