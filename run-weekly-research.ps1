# ============================================================
# WEEKLY RESEARCH RUNNER
# Triggered by Windows Task Scheduler every Monday morning
# Runs the Claude Code agent team, then emails the report
# ============================================================

$WorkDir   = "C:\Users\NN Leptop 33\Claude Agents"
$LogFile   = "$WorkDir\logs\run-$(Get-Date -Format 'yyyy-MM-dd').log"
$DateStamp = Get-Date -Format "yyyy-MM-dd"

# Ensure logs folder exists
New-Item -ItemType Directory -Force -Path "$WorkDir\logs" | Out-Null

function Log($msg) {
    $line = "$(Get-Date -Format 'HH:mm:ss') — $msg"
    Write-Host $line
    Add-Content -Path $LogFile -Value $line
}

Log "=== Weekly research run started ==="
Log "Working directory: $WorkDir"

# ── Step 1: Run Claude Code agent team ────────────────────────────────────────

$claudePrompt = @"
Read the file at: C:\Users\NN Leptop 33\Claude Agents\research-context.md

This file contains full context about who we are, what to research, and which companies to cover.

Your job:
1. Spawn these 4 agents IN PARALLEL using their definitions in .claude/agents/:
   - market-researcher
   - services-analyst
   - reviews-strategist
   - market-entry-strategist

   Each agent should save their findings as markdown files to:
   C:\Users\NN Leptop 33\Claude Agents\

2. Wait for all 4 agents to complete their research.

3. Once all 4 are done, spawn the report-synthesizer agent (from .claude/agents/).
   Pass it the paths to all 4 research files.
   It will produce a final HTML report saved to:
   C:\Users\NN Leptop 33\Claude Agents\india-school-services-report-$DateStamp.html

4. Confirm when the HTML report has been saved successfully.
"@

Log "Starting Claude Code research agents..."

# Run claude CLI in the working directory
# --print flag runs non-interactively and exits when done
Push-Location $WorkDir
try {
    $claudeOutput = & claude --print $claudePrompt 2>&1
    $exitCode = $LASTEXITCODE
} finally {
    Pop-Location
}

Log "Claude Code exited with code: $exitCode"

if ($exitCode -ne 0) {
    Log "ERROR: Claude Code did not complete successfully."
    Log "Output: $claudeOutput"
    exit 1
}

# ── Step 2: Verify report was created ─────────────────────────────────────────

$reportPath = "$WorkDir\india-school-services-report-$DateStamp.html"

if (!(Test-Path $reportPath)) {
    # Try finding any report created today
    $reportPath = Get-ChildItem -Path $WorkDir -Filter "india-school-services-report-*.html" |
        Where-Object { $_.LastWriteTime -gt (Get-Date).AddHours(-2) } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1 -ExpandProperty FullName

    if ($null -eq $reportPath) {
        Log "ERROR: HTML report not found. Research may have failed."
        exit 1
    }
}

Log "Report found: $reportPath"

# ── Step 3: Send email ─────────────────────────────────────────────────────────

Log "Sending email..."

& "$WorkDir\send-report-email.ps1" -ReportPath $reportPath

if ($LASTEXITCODE -eq 0) {
    Log "Email sent successfully."
    Log "=== Run completed successfully ==="
} else {
    Log "ERROR: Email failed to send. Report is saved at: $reportPath"
    exit 1
}
