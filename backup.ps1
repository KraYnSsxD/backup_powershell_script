# Configuration
$SourceDir = "C:\Company_Base"
$BackupDir = "C:\Local_Backup"
$LogFile = "C:\Local_Backup\backup_log.txt"
$DaysToKeep = 7

# Function to write logs with timestamp
function Write-Log ($Message, $Type = "INFO") {
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogMessage = "[$Timestamp] [$Type] $Message"
    
    # Simple and robust color selection
    $Color = "Green"
    if ($Type -eq "ERROR") { $Color = "Red" }
    if ($Type -eq "WARNING") { $Color = "Yellow" }
    
    # Write to console and file
    Write-Host $LogMessage -ForegroundColor $Color
    Add-Content -Path $LogFile -Value $LogMessage
}

Write-Log "========================================"
Write-Log "Backup process started."

# Generate timestamp and file path
$CurrentDate = Get-Date -Format "yyyy-MM-dd_HH-mm"
$ZipFileName = "Backup_$CurrentDate.zip"
$TargetZipPath = Join-Path $BackupDir $ZipFileName

# Create backup directory if it doesn't exist
if (!(Test-Path $BackupDir)) { 
    try {
        New-Item -ItemType Directory -Path $BackupDir -ErrorAction Stop
        Write-Log "Backup directory created successfully."
    } catch {
        Write-Log "Failed to create backup directory: $_" "ERROR"
        Exit
    }
}

# 1. Create new backup
try {
    Compress-Archive -Path $SourceDir -DestinationPath $TargetZipPath -Force -ErrorAction Stop
    Write-Log "New backup created successfully: $ZipFileName"
} catch {
    Write-Log "Backup creation FAILED: $_" "ERROR"
    Exit
}

# 2. Retention Policy: Delete files older than $DaysToKeep
try {
    $LimitDate = (Get-Date).AddDays(-$DaysToKeep)
    $OldFiles = Get-ChildItem -Path $BackupDir -Filter "*.zip" | Where-Object { 
        $_.CreationTime -lt $LimitDate -or $_.LastWriteTime -lt $LimitDate 
    }

    if ($OldFiles) {
        foreach ($file in $OldFiles) {
            Remove-Item $file.FullName -Force
            Write-Log "Purged old backup file: $($file.Name)" "WARNING"
        }
    } else {
        Write-Log "No old backups found to purge."
    }
} catch {
    Write-Log "Error during retention policy execution: $_" "ERROR"
}

Write-Log "Backup process finished successfully."