#!/bin/bash


#####################
# Configuration     #
#####################
DIR_DOTFILES="$(realpath "$(dirname "$0")")"
DIR_DOTFILES_BACKUP="$HOME/.dotfiles.backup"
CMD_INSTALL_DOTFILE="stow -d $DIR_DOTFILES -t $HOME --ignore=install.sh"
CMD_UNINSTALL_DOTFILE="stow -d $DIR_DOTFILES -t $HOME --ignore=install.sh -D"


#####################
# Environment       #
#####################
# Source os release info
if test -f /etc/os-release; then
    . /etc/os-release
fi;

#####################
# Functions         #
#####################
function installPackage() {
    # Debian/Buntu
    if [[ "$NAME" == "Ubuntu" || $NAME == "Debian" ]]; then
        if ! $(dpkg -l ${@} &>/dev/null); then
            sudo apt-get install -y ${@}
        fi;
    elif [[ "$NAME" == "Void" ]]; then
        echo "sudo xbps-install -Rs ${@}"
    fi;
}

function backupDotfile() {
    echo "Backup existing dotfile \"$1\" to \"$DIR_DOTFILES_BACKUP\""
    echo "Function not implemented yet"
    exit 1
}

function restoreDotfile() {
    echo "restoreDotfile not implemented yet"
    exit 1
}

function installDotfile() {
    echo "Installing dotfile \"$1\":"
    echo "-----------------------------------"

    if [ -n "$(find $DIR_DOTFILES/$1 -maxdepth 2 -empty -type d 2>/dev/null)" ]; then
        echo "Empty dotfile source directory \"$DIR_DOTFILES/$1\", skipping"
        return
    fi;

    $CMD_INSTALL_DOTFILE "$1"
    case $? in
        "0")
            echo "Dotfile \"$1\" installed successfully"
            ;;
        "1")
            echo "Dotfile installation for \"$1\" failed, move(backup) your existing dotfiles and retry"
            # Determine if we need to move existing dotfiles to $DIR_DOTFILES_BACKUP
            return 1
            ;;
        "2")
            echo "Dotfile \"$1\" not found"
            return 1
            ;;
    esac

    install_script="$DIR_DOTFILES/$1/install.sh"
    if [ -f "$install_script" ]; then
        cd "$DIR_DOTFILES/$1/"
        echo "Executing install script for $1 dotfile"
        source "$install_script"
    fi
}

function uninstallDotfile() {
    echo "uninstallDotfile not implemented yet"
    exit 1
}

function installAllDotfiles() {
    for dot in $(find $DIR_DOTFILES/* -maxdepth 0 -type d); do
        read -rp "Do you want to install dotfile $(basename "$dot")? (y/N): " yn </dev/tty
        if [[ $yn =~ ^[Yy]$ ]]; then
            installDotfile "$(basename "$dot")"
        else
            echo "Skipped"
        fi
    done
}

function uninstallAllDotfiles() {
    echo "uninstallAllDotfiles not implemented yet"
    exit 1
}

function usage() {
    echo "Usage: $0 [install|uninstall] [dotfile]"
    echo "  install: Installs a single dotfile, starts a wizzard if dotfile is omitted"
    echo "  uninstall: Uninstalls all dotfiles / dotfile"
}


#####################
# Main              #
#####################

# Ensure runtime dependencies
if ! installPackage git stow; then echo "Runtime dependecies not installed"; exit 1; fi;

# TODO: Finish / replace with yadm
if [ "$1" == "install" ]; then
    if [ -z $2 ]; then
        installAllDotfiles
    else
        installDotfile "$2"
    fi;
elif [ "$1" == "uninstall" ]; then
    if [ -z $2 ]; then
        uninstallAllDotfiles
    else
        uninstallDotfile "$2"
    fi;
else usage; fi;

exit $?
