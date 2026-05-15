# ============================================================
# SETUP WINDOWS TASK SCHEDULER
# Run this script ONCE to register the weekly research task
# Run as Administrator for best results
# ============================================================

$TaskName   = "WeeklySchoolServicesResearch"
$ScriptPath = "C:\Users\NN Leptop 33\Claude Agents\run-weekly-research.ps1"
$WorkDir    = "C:\Users\NN Leptop 33\Claude Agents"

# Schedule: Every Monday at 9:00 AM (India time = your local time)
$trigger = New-ScheduledTaskTrigger `
    -Weekly `
    -DaysOfWeek Monday `
    -At "09:00AM"

# Action: run PowerShell with the runner script
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NonInteractive -ExecutionPolicy Bypass -File `"$ScriptPath`"" `
    -WorkingDirectory $WorkDir

# Settings: run even if on battery, don't stop after 1hr (research takes ~10-15 min)
$settings = New-ScheduledTaskSettingsSet `
    -ExecutionTimeLimit (New-TimeSpan -Hours 1) `
    -RunOnlyIfNetworkAvailable `
    -StartWhenAvailable `
    -DontStopIfGoingOnBatteries `
    -WakeToRun

# Register the task for the current user
Register-ScheduledTask `
    -TaskName $TaskName `
    -Trigger $trigger `
    -Action $action `
    -Settings $settings `
    -RunLevel Highest `
    -Force

Write-Host ""
Write-Host "Task registered successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Task name : $TaskName"
Write-Host "Runs      : Every Monday at 9:00 AM"
Write-Host "Script    : $ScriptPath"
Write-Host ""
Write-Host "To verify, open Task Scheduler and look for: $TaskName"
Write-Host "To run it manually right now: Start-ScheduledTask -TaskName '$TaskName'"
Write-Host "To remove it: Unregister-ScheduledTask -TaskName '$TaskName' -Confirm:`$false"
