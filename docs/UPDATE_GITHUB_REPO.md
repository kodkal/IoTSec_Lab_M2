# Updating Your GitHub Repository

## Files to Add/Update

### New Files to Add:
1. **quickstart.sh** - One-command setup script
2. **STUDENT_QUICK_GUIDE.md** - Simplified student instructions
3. **.gitignore** - Ignore unnecessary files
4. **templates/** folder - If not already present

### Files to Update:
1. **README.md** - Replace with README_GITHUB.md content
2. **setup.sh** - Update with IP detection code

## Steps to Update Your Repository

### 1. On Your Local Machine (Mac)

```bash
# Clone your repository locally
cd ~/Desktop  # or wherever you want to work
git clone https://github.com/kodkal/IoTSec_Lab_M2.git
cd IoTSec_Lab_M2
```

### 2. Add the New Files

Download these files and add them to your repository:
- quickstart.sh
- STUDENT_QUICK_GUIDE.md
- GITHUB_SETUP_INSTRUCTIONS.md
- .gitignore

### 3. Ensure Templates Folder Exists

The templates folder must contain:
- index.html
- login.html

If missing, extract from IoT_Security_Lab1.tar.gz:
```bash
tar -xzf IoT_Security_Lab1.tar.gz
cp -r IoT_Security_Lab1_Package/templates .
```

### 4. Make Scripts Executable and Commit

```bash
# Make scripts executable
chmod +x quickstart.sh setup.sh reset_lab.sh

# Add all files
git add .

# Commit changes
git commit -m "Added quickstart script and improved setup instructions for GitHub workflow"

# Push to GitHub
git push origin main
```

## Testing the Updated Repository

### On a Fresh Raspberry Pi:

```bash
# SSH to a test Pi
ssh pi@raspberrypi.local

# Clone and test
git clone https://github.com/kodkal/IoTSec_Lab_M2.git
cd IoTSec_Lab_M2
./quickstart.sh
```

## What Students Will Do

With your updated repository, students only need to:

1. SSH to their Pi
2. Clone your repo: `git clone https://github.com/kodkal/IoTSec_Lab_M2.git`
3. Run: `cd IoTSec_Lab_M2 && ./quickstart.sh`
4. Access the app from their browser

## Repository Structure Should Be:

```
IoTSec_Lab_M2/
├── README.md                      # Main documentation
├── quickstart.sh                  # NEW: One-click setup
├── setup.sh                       # Original setup script
├── reset_lab.sh                   # Reset script
├── vulnerable_iot_app.py          # Main application
├── requirements.txt               # Python dependencies
├── templates/                     # REQUIRED folder
│   ├── index.html                # Dashboard
│   └── login.html                # Login page
├── LAB1_Student_Worksheet.md      # Full worksheet
├── STUDENT_QUICK_GUIDE.md        # NEW: Quick reference
├── LAB1_Instructor_Guide.md      # Instructor solutions
├── QUICK_REFERENCE.md            # Command reference
├── NETWORK_DISCOVERY_GUIDE.md    # IP finding guide
├── .gitignore                    # NEW: Git ignore file
└── IoT_Security_Lab1.tar.gz      # Optional: Full package

```

## Making Repository Public vs Private

### For Private Repository (Recommended during active class):
- Students need GitHub accounts
- Add students as collaborators: Settings → Manage access → Add people
- Or create a personal access token for the class

### For Public Repository (After semester):
- Anyone can clone
- Consider removing instructor guide with solutions
- Add clear warnings about educational use only

## Quick Fixes for Common Issues

### If templates folder is missing:
```bash
mkdir templates
# Copy index.html and login.html into templates/
```

### If students can't clone (private repo):
```bash
# Option 1: Make repo public temporarily during lab
# Option 2: Provide personal access token:
git clone https://[TOKEN]@github.com/kodkal/IoTSec_Lab_M2.git
# Option 3: Use SSH keys (more complex)
```

### To update student's existing clone:
```bash
cd ~/IoTSec_Lab_M2
git pull
./quickstart.sh
```