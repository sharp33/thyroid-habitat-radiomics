#requires -Version 5.1
<#
.SYNOPSIS
    One-shot push of the thyroid-habitat-radiomics repository to GitHub.

.DESCRIPTION
    This script configures git, creates a first commit, and pushes the
    repository to a GitHub repo that you create beforehand.

    The companion repository (https://github.com/sharp33/thyroid-habitat-radiomics)
    is set to **public** to comply with the data-sharing policy of BMC
    Medical Imaging. The same code can be re-deployed to a private mirror
    by creating a new private repository on GitHub and pointing this
    script at it; only the GitHub visibility setting differs.

    You need to:
      1. Generate a GitHub Personal Access Token (PAT) with `repo` scope.
         https://github.com/settings/tokens/new
         - Expiration: 90 days or less (rotate later)
         - Scopes: "repo" (full control of private repositories)
         - Copy the token (you will only see it once).

      2. Create a repository on GitHub.
         https://github.com/new
         - Owner:  your account (e.g. zhoujing-ai)
         - Name:   thyroid-habitat-radiomics
         - Visibility: Public (matches BMC Medical Imaging's open-access
           data-sharing policy) or Private (if hosting a private mirror).
         - DO NOT initialize with README, .gitignore, or license
           (this script will push them).

    The script will then ask for your GitHub username, the PAT, and the
    remote URL, and push the commit.
#>

[CmdletBinding()]
param(
    [string]$RepoUrl = "",
    [string]$GitUserName = "",
    [string]$GitUserEmail = ""
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $ScriptDir

function Write-Step($msg) {
    Write-Host ""
    Write-Host "=== $msg ===" -ForegroundColor Cyan
}

Write-Step "Pre-flight checks"
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "git not found on PATH. Install Git for Windows and retry."
    exit 1
}
Write-Host "  git found: $(git --version)"

# --- 1. Identity ---
Write-Step "Git identity"
if (-not $GitUserName) {
    $GitUserName = Read-Host "Your name (for git commits, e.g. 'Dawei Sun')"
}
if (-not $GitUserEmail) {
    $GitUserEmail = Read-Host "Your email (e.g. 1024189695@qq.com)"
}
git config user.name  $GitUserName
git config user.email $GitUserEmail
Write-Host "  user.name  = $GitUserName"
Write-Host "  user.email = $GitUserEmail"

# --- 2. Initialise the repo ---
Write-Step "Initialise git repository"
if (-not (Test-Path -LiteralPath ".git" -PathType Container)) {
    git init -b main | Out-Null
    Write-Host "  Initialised empty repo on branch main."
} else {
    Write-Host "  .git already exists; re-using."
}

# --- 3. Stage and commit ---
Write-Step "Stage and commit"
git add -A
$stagedCount = (git diff --cached --name-only | Measure-Object -Line).Lines
Write-Host "  $stagedCount files staged."

if ($stagedCount -eq 0) {
    Write-Host "  Nothing to commit (working tree clean). Skipping commit."
} else {
    $commitMsg = "Initial commit: Habitat radiomics for PTC central-compartment LN metastasis"
    git commit -m $commitMsg | Out-Null
    Write-Host "  Committed: $commitMsg"
}

# --- 4. Remote URL ---
Write-Step "Configure remote"
if (-not $RepoUrl) {
    $defaultUrl = "https://github.com/REPLACE_WITH_OWNER/thyroid-habitat-radiomics.git"
    $inputUrl = Read-Host "Repository URL (Enter for default: $defaultUrl)"
    if ([string]::IsNullOrWhiteSpace($inputUrl)) {
        $RepoUrl = $defaultUrl
    } else {
        $RepoUrl = $inputUrl
    }
}

# Detect existing remote
$existingRemote = git remote get-url origin 2>$null
if ($existingRemote) {
    Write-Host "  origin already set to: $existingRemote"
    $change = Read-Host "  Replace with $RepoUrl ? (y/N)"
    if ($change -eq 'y' -or $change -eq 'Y') {
        git remote set-url origin $RepoUrl
        Write-Host "  Updated."
    }
} else {
    git remote add origin $RepoUrl
    Write-Host "  Added origin -> $RepoUrl"
}

# --- 5. Push ---
Write-Step "Push to GitHub"
Write-Host "  You will be prompted for a GitHub username and a Personal Access Token (PAT)."
Write-Host "  Generate a PAT at: https://github.com/settings/tokens/new"
Write-Host "  Scopes needed: 'repo' (full control of private repositories)."
Write-Host ""

# Use a one-shot credential helper to avoid saving the PAT in plain text
$credHelperCmd = '!f() { echo username=$1; echo password=$2; }; f'
git config --global --replace-all credential.helper ""
git config --replace-all credential.helper ""
git config credential.helper "$credHelperCmd"

# Push, prompting for credentials
git push -u origin main

# Clean up: drop the in-script credential helper
git config --unset credential.helper 2>$null

Write-Step "Done"
if ($LASTEXITCODE -eq 0) {
    Write-Host "  Push succeeded. Visit: $RepoUrl" -ForegroundColor Green
} else {
    Write-Host "  Push failed. See errors above." -ForegroundColor Red
}
