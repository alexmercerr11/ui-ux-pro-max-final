# install-skills.ps1
# Installs UI/UX Pro Max and Marketing skills into your local Claude Code CLI.
# Run from PowerShell: .\install-skills.ps1

$SkillsDir = Join-Path $env:USERPROFILE ".claude\skills"
$ReposDir  = Join-Path $env:USERPROFILE ".claude\skill-repos"

Write-Host "Setting up Claude Code skills..." -ForegroundColor Cyan

New-Item -ItemType Directory -Force -Path $SkillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $ReposDir  | Out-Null

function Clone-Or-Pull ($url, $name) {
    $dest = Join-Path $ReposDir $name
    if (Test-Path (Join-Path $dest ".git")) {
        Write-Host "  Updating $name..."
        git -C $dest pull --ff-only --quiet
    } else {
        Write-Host "  Cloning $name..."
        git clone --depth=1 --quiet $url $dest
    }
}

Clone-Or-Pull "https://github.com/alexmercerr11/ui-ux-pro-max-final.git"  "ui-ux-pro-max-final"
Clone-Or-Pull "https://github.com/alexmercerr11/marketingskills-final.git" "marketingskills-final"

Write-Host "  Copying UI/UX skills..."
$uiSkillsPath = Join-Path $ReposDir "ui-ux-pro-max-final\.claude\skills"
Get-ChildItem $uiSkillsPath -Directory | ForEach-Object {
    $dest = Join-Path $SkillsDir $_.Name
    Copy-Item -Recurse -Force $_.FullName $dest
}

Write-Host "  Copying marketing skills..."
$mktSkillsPath = Join-Path $ReposDir "marketingskills-final\skills"
Get-ChildItem $mktSkillsPath -Directory | ForEach-Object {
    $dest = Join-Path $SkillsDir $_.Name
    Copy-Item -Recurse -Force $_.FullName $dest
}

$count = (Get-ChildItem $SkillsDir -Directory).Count
Write-Host ""
Write-Host "Done! $count skills installed in $SkillsDir" -ForegroundColor Green
Write-Host "Restart Claude Code — all skills will be available immediately."
