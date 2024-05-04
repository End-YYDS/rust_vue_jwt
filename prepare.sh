#!/bin/bash

projectPath=$(dirname "$0")

ensure_command_exists() {
    command=$1
    install_script=$2

    if ! command -v $command &> /dev/null; then
        echo "$command is not installed. Attempting to install..."
        eval $install_script
        if ! command -v $command &> /dev/null; then
            echo "Failed to install $command. Please install it manually and try again."
            exit 1
        fi
    fi
    echo "$command is available."
}

git_install_script() {
    git_url="https://api.github.com/repos/git-for-windows/git/releases/latest"
    asset_name=$(curl -s $git_url | grep -oP '"name": "\K[^"]+64-bit.exe')
    installer="/tmp/$asset_name"
    curl -L $(curl -s $git_url | grep -oP '"browser_download_url": "\K[^"]+') -o $installer
    chmod +x $installer
    $installer /SP- /VERYSILENT /SUPPRESSMSGBOXES /NOCANCEL /NORESTART /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS
}

npm_install_script() {
    installer="/tmp/node-v20.12.2-x64.msi"
    curl -L "https://nodejs.org/dist/v20.12.2/node-v20.12.2-x64.msi" -o $installer
    sudo msiexec /i $installer /quiet
}

rust_install_script() {
    installer="/tmp/rustup-init.exe"
    curl -L "https://static.rust-lang.org/rustup/dist/i686-pc-windows-gnu/rustup-init.exe" -o $installer
    chmod +x $installer
    $installer -y
}

ensure_command_exists "git" "brew install git"
ensure_command_exists "npm" "brew install node@20"
ensure_command_exists "cargo" "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

cd $projectPath/frontend
echo "Running npm install..."
npm install
if [ $? -ne 0 ]; then
    echo "npm install failed with exit code $?"
    exit $?
fi

cd $projectPath/backend
echo "Running cargo build..."
cargo build
if [ $? -ne 0 ]; then
    echo "cargo build failed with exit code $?"
    exit $?
fi

cd $projectPath
echo "All operations completed successfully."
