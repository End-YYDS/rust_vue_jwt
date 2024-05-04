$projectPath = $PSScriptRoot
function Ensure-CommandExists {
    param (
        [string]$command,
        [string]$installScript
    )
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    if (-not $exists) {
        Write-Host "$command is not installed. Attempting to install..."
        Invoke-Expression $installScript
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
        if (-not $exists) {
            Write-Host "Failed to install $command. Please install it manually and try again."
            exit
        }
    }
    Write-Host "$command is available."
}

$gitInstallScript = {
    $git_url = "https://api.github.com/repos/git-for-windows/git/releases/latest"
    $asset = Invoke-RestMethod -Method Get -Uri $git_url | % assets | where name -like "*64-bit.exe"
    $installer = "$env:temp\$($asset.name)"
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $installer
    $git_install_inf = "$projectPath\Config\git.cfg"
    $install_args = "/SP- /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /LOADINF=$($git_install_inf)"
    Start-Process -FilePath $installer -ArgumentList "$install_args" -Wait
}

$npmInstallScript = {
    $asset = "node-v20.12.2-x64.msi"
    $installer = "$env:temp\$($asset)"
    Invoke-WebRequest -Uri "https://nodejs.org/dist/v20.12.2/node-v20.12.2-x64.msi" -OutFile $installer
    Start-Process powershell -verb runas -ArgumentList "msiexec.exe /i $installer /quiet" -Wait
}

$rustInstallScript = {
    $asset = "rustup-init.exe"
    $installer = "$env:temp\$($asset)"
    Invoke-WebRequest -Uri "https://static.rust-lang.org/rustup/dist/i686-pc-windows-gnu/rustup-init.exe" -OutFile $installer
    $install_args = "-y"
    Start-Process -FilePath $installer -ArgumentList "$install_args" -Wait
}

Ensure-CommandExists -command "git" -installScript $gitInstallScript
Ensure-CommandExists -command "npm" -installScript $npmInstallScript
Ensure-CommandExists -command "cargo" -installScript $rustInstallScript


Set-Location -Path $projectPath/frontend

# Write-Host "Running git push..."
# git push
# if ($LastExitCode -ne 0) {
#     Write-Host "git push failed with exit code $LastExitCode"
#     exit $LastExitCode
# }

Write-Host "Running npm install..."
npm install
if ($LastExitCode -ne 0) {
    Write-Host "npm install failed with exit code $LastExitCode"
    exit $LastExitCode
}
Set-Location -Path $projectPath/backend
Write-Host "Running cargo build..."
cargo build
if ($LastExitCode -ne 0) {
    Write-Host "cargo build failed with exit code $LastExitCode"
    exit $LastExitCode
}
Set-Location -Path $projectPath
Write-Host "All operations completed successfully."
