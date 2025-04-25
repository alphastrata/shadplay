<#
.SYNOPSIS
Installs bevy_lint and the bevy-cli.
#>

# 1. Check/install Rust (user-level)
if (-not (Get-Command rustup -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Rust for current user..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri "https://sh.rustup.rs" -OutFile "$env:TEMP\rustup-init.exe"
    Start-Process -Wait -FilePath "$env:TEMP\rustup-init.exe" -ArgumentList "-y --no-modify-path"
    $env:Path = "$env:USERPROFILE\.cargo\bin;" + $env:Path
}

# 2. Get latest bevy_lint release
try {
    $release = Invoke-RestMethod "https://api.github.com/repos/TheBevyFlock/bevy_cli/releases/latest"
    $TAG = $release.tag_name
    Write-Host "Latest bevy_lint: $TAG" -ForegroundColor Cyan
}
catch {
    Write-Warning "Failed to fetch release; falling back to v0.2.0"
    $TAG = "lint-v0.2.0"  # Note: Bevy tags use "lint-" prefix
}

# 3. Detect required nightly version
$nightly = (Invoke-WebRequest "https://thebevyflock.github.io/bevy_cli/bevy_lint/#compatibility" -UseBasicParsing).RawContent |
Select-String -Pattern "nightly-\d{4}-\d{2}-\d{2}" |
Select-Object -First 1 -ExpandProperty Matches |
ForEach-Object { $_.Value }

if (-not $nightly) {
    $nightly = "nightly"
    Write-Warning "Using latest nightly (version not detected)"
}

# 4. Install toolchain with CORRECT component syntax
Write-Host "Installing Rust toolchain: $nightly" -ForegroundColor Cyan
rustup toolchain install $nightly --profile minimal
rustup component add --toolchain $nightly rustc-dev llvm-tools-preview
rustup default $nightly

# 5. Install bevy_lint
Write-Host "Installing bevy_lint..." -ForegroundColor Cyan
& cargo install --git https://github.com/TheBevyFlock/bevy_cli.git --tag $TAG --locked bevy_lint

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Installed successfully!" -ForegroundColor Green
}
else {
    Write-Host "✗ Installation failed" -ForegroundColor Red
    exit 1
}