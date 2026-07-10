# Automated Windows Backup Script with Retention & Logging

A lightweight, enterprise-ready PowerShell script designed for automated local backups. Perfect for small businesses, 1C databases, or personal files. It compresses data into ZIP archives, manages disk space using a retention policy, and writes detailed execution logs.

## Features
- **ZIP Compression:** Automatically packages the source directory using a timestamped filename.
- **Smart Retention Policy:** Automatically purges old backups (older than 7 days) based on both Creation and Modification dates to prevent disk overflow.
- **Robust Logging:** Writes clear, structured logs (`backup_log.txt`) with custom colors in the console and full exception handling (`try/catch`).
- **Automation Ready:** Designed to run silently via Windows Task Scheduler.

---

## Deployment & Installation

### Step 1: Prepare Directories
1. Create your source directory containing the files you want to back up (e.g., `C:\Company_Base`).
2. Create your backup destination directory (e.g., `C:\Local_Backup`).
3. Place the `backup.ps1` script into your preferred working folder (e.g., `C:\Backup_System\backup.ps1`).

*Note: You can easily modify the directory paths and retention days ($DaysToKeep) inside the configuration block at the top of the script.*

### Step 2: Bypass Windows Execution Policy
By default, Windows blocks the execution of untrusted PowerShell scripts. To run or test this script, use one of the following administrative workarounds:

**Option A: Bypass for the current user only (No permanent system changes)**
Open PowerShell and run:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force```
**Option B: Direct execution bypass (One-time run without altering policies)**
Run the script explicitly by ignoring the execution restrictions:
```PowerShell
PowerShell.exe -ExecutionPolicy Bypass -File "C:\Backup_System\backup.ps1"```

### Step 3: Automate with Windows Task Scheduler
To make the backup fully autonomous, register it as a daily background task. Open PowerShell as Administrator and execute the following command:
PowerShell

```Register-ScheduledTask -TaskName "Company_Auto_Backup" -Trigger (New-ScheduledTaskTrigger -Daily -At 3:00AM) -Action (New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File C:\Backup_System\backup.ps1") -Description "Automated database backup with retention policy" -Force```

### Log Output Example

When executed successfully, the console and backup_log.txt will output:
```Plaintext
[2026-07-10 23:19:16] [INFO] ========================================
[2026-07-10 23:19:16] [INFO] Backup process started.
[2026-07-10 23:19:16] [INFO] New backup created successfully: Backup_2026-07-10_23-19.zip
[2026-07-10 23:19:16] [INFO] No old backups found to purge.
[2026-07-10 23:19:16] [INFO] Backup process finished successfully.```
