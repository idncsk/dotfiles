#!/bin/bash


# Configuration section
# Taken from a different setup, fixme
DIR_PORTABLE=$HOME/Portable

# Define ANSI escape codes for bold green text
BOLD_GREEN='\033[1;32m'
BOLD_RED='\033[1;31m'
RESET='\033[0m'

# Check if the distribution is Ubuntu and the version is Jammy
if [[ "$(lsb_release -is)" != "Ubuntu" ]] || [[ "$(lsb_release -cs)" != "jammy" ]]; then
    echo "This script is only for Ubuntu Jammy."
    exit 1
fi

# Ensure system is up-to-date
echo -e "${BOLD_GREEN}Updating system packages${RESET}"
sudo apt-get update && sudo apt-get upgrade

# Update KDE Plasma
sudo add-apt-repository ppa:kubuntu-ppa/backports
sudo apt full-upgrade

# Install base packages
echo -e "${BOLD_GREEN}Installing base packages${RESET}"

# Package installer Debian/Ubuntu
function installPackage {
    # Read the package name from the argument
    package=$1

    # Check if the package is already installed
    if dpkg-query -W $package >/dev/null 2>&1; then
        echo -e "${BOLD_GREEN}$package is already installed.${RESET}"
        return
    fi

    # Install the package
    echo "Installing $package..."
    if sudo apt-get install -y $package >/dev/null 2>&1; then
        echo -e "${BOLD_GREEN}$package has been installed.${RESET}"
    else
        echo -e "${BOLD_RED}Error: failed to install $package.${RESET}"
    fi
}

# Read the list of packages from the packages file and install each one
packages_file="packages.ubuntu"
while read line; do
    # Skip empty lines and comments
    if [[ $line =~ ^[[:space:]]*# || $line =~ ^[[:space:]]*$ ]]; then
        continue
    fi
    installPackage $line
done <$packages_file

# QF For apt
if ! test -d /etc/apt/sources.list.d/; then mkdir -p /etc/apt/sources.list.d/; fi

# Check if OBS Studio is already installed
if command -v obs &>/dev/null; then
    echo -e "${BOLD_GREEN}OBS Studio is already installed.${RESET}"
else
    # Check if OBS Studio repository is already installed
    if ! grep -q "^deb .*obsproject" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        # Add OBS Studio sources
        sudo add-apt-repository ppa:obsproject/obs-studio
    fi

    # Install OBS Studio
    sudo apt-get update && sudo apt-get install -y obs-studio
fi

# Check if VSCode is already installed
if command -v code &>/dev/null; then
    echo -e "${BOLD_GREEN}VSCode is already installed.${RESET}"
else
    # Check if VSCode repository is already installed
    if ! grep -q "^deb .*https://packages.microsoft.com/repos/vscode" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        # Add VSCode sources
        wget -O- https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor | sudo tee /usr/share/keyrings/vscode.gpg
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
    fi

    # Install VSCode
    sudo apt-get update && sudo apt-get install -y code
fi

# Check if lsd is already installed
if command -v lsd &>/dev/null; then
    echo -e "${BOLD_GREEN}lsd is already installed.${RESET}"
else
    # Fetch and install lsd deb package
    wget https://github.com/Peltoche/lsd/releases/download/0.20.1/lsd_0.20.1_amd64.deb -P /tmp
    sudo dpkg -i /tmp/lsd_0.20.1_amd64.deb
fi

# Check if Node.js is already installed
if command -v node &>/dev/null; then
    echo -e "${BOLD_GREEN}Node.js is already installed.${RESET}"
else
    # Install Node.js
    echo "Installing Node.js"
    cd /tmp
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Check if Yarn is already installed
if command -v yarn &>/dev/null; then
    echo -e "${BOLD_GREEN}Yarn is already installed.${RESET}"
else
    # Install Yarn
    echo -e "${BOLD_GREEN}Installing Yarn${RESET}"
    curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update && sudo apt-get install -y yarn
fi

# Ensure basic directory structure
if ! test -d $DIR_PORTABLE; then mkdir $DIR_PORTABLE; fi
#if ! -d ~/Portable/Apps; then git clone http://code.idnc.sk/idnc_sk/apps.git ~/Portable/Apps; fi;
if ! test -d $DIR_PORTABLE/Apps; then mkdir $DIR_PORTABLE/Apps; fi

#if ! -d ~/Portable/Roles; then git clone http://code.idnc.sk/idnc_sk/roles.git ~/Portable/Roles; fi;
if ! test -d $DIR_PORTABLE/Roles; then mkdir $DIR_PORTABLE/Roles; fi

#if ! -d ~/Portable/Utils; then git clone http://code.idnc.sk/idnc_sk/utils.git ~/Portable/Utils; fi;
if ! test -d $DIR_PORTABLE/Utils; then mkdir $DIR_PORTABLE/Utils; fi

if ! test -d $DIR_PORTABLE/Dotfiles; then git clone http://code.idnc.sk/idnc_sk/dotfiles.git $DIR_PORTABLE/Dotfiles; fi
if ! test -d $DIR_PORTABLE/Home; then mkdir $DIR_PORTABLE/Home; fi

exit 0
