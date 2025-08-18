# Always run from the folder this script lives in
Set-Location -Path $PSScriptRoot

# Sanity checks
if (-not (Test-Path ".git")) {
  Write-Error "❌ This folder is not a Git repo: $PWD"
  exit 1
}
if (-not (git remote -v 2>$null)) {
  Write-Error "❌ No Git remote configured. Run: git remote add origin https://github.com/dylonbryant/myblog.git"
  exit 1
}

# Stage changes
git add -A

# Commit only if something changed
$changed = (git status --porcelain) -ne $null
if ($changed) {
  $msg = "Publish: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
  git commit -m $msg
  git push origin main
  Write-Host "✅ Pushed: $msg"
} else {
  Write-Host "ℹ️ No changes to publish."
}
