# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# bashrc color codes 
# TODO: Replace with global codes from env
COLOR_RESET="\033[0m"

COLOR_BLACK="\033[0;30m"
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[0;33m"
COLOR_BLUE="\033[0;34m"
COLOR_MAGENTA="\033[0;35m"
COLOR_CYAN="\033[0;36m"
COLOR_WHITE="\033[0;37m"

COLOR_BOLD_BLACK="\033[1;30m"
COLOR_BOLD_RED="\033[1;31m"
COLOR_BOLD_GREEN="\033[1;32m"
COLOR_BOLD_YELLOW="\033[1;33m"
COLOR_BOLD_BLUE="\033[1;34m"
COLOR_BOLD_MAGENTA="\033[1;35m"
COLOR_BOLD_CYAN="\033[1;36m"
COLOR_BOLD_WHITE="\033[1;37m"


#####################
# Common imports    #
#####################
if test -f $HOME/.shell/env; then
    . $HOME/.shell/env
fi;

if test -f $HOME/.shell/functions; then
    . $HOME/.shell/functions
fi;

if test -f $HOME/.shell/aliases; then
    . $HOME/.shell/aliases
fi;


#####################
# Custom imports    #
#####################
if test -f $HOME/.shell/env.custom; then
    . $HOME/.shell/env.custom
fi;

if test -f $HOME/.shell/functions.custom; then
    . $HOME/.shell/functions.custom
fi;

if test -f $HOME/.shell/aliases.custom; then
    . $HOME/.shell/aliases.custom
fi;


# Recursive globbing with "**"
shopt -s globstar

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Do not autocomplete when accidentally pressing Tab on an empty line.
shopt -s no_empty_cmd_completion

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize


#####################
# Prompt            #
#####################
if [[ $EUID -eq 0 ]]; then
    PS1="\[${BOLD}${RED}\]\u \[$BASE0\]at \[$CYAN\]\h \[$BASE0\]in \[$BLUE\]\w\[$BASE0\]\n\$ \[$RESET\]"
else
    #PS1="\[${BOLD}${CYAN}\]\u \[$BASE0\]at \[$CYAN\]\h \[$BASE0\]in \[$BLUE\]\w\[$BASE0\]\n\$ \[$RESET\]"
    PS1="\[${BOLD}${CYAN}\]\u \[$BASE0\]at \[$CYAN\]\h \[$BASE0\]in \[$BLUE\]\w\[$BASE0\]\$([[ -n \$(git branch 2> /dev/null) ]] && echo \" on \")\[$YELLOW\]\$(parse_git_branch)\[$BASE0\]\n\$ \[$RESET\]"
fi;

if [ "$CHROOT" == "true" ]; then
    PS1="(chroot) $PS1"
fi;


#####################
# Bash history      #
#####################
export HISTSIZE=32768;
export HISTFILESIZE="${HISTSIZE}";
export SAVEHIST=4096
export HISTCONTROL=ignoredups:erasedups
export HISTTIMEFORMAT="$(echo -e $COLOR_BLUE[%F %T]$COLOR_RESET) "

# append to the history file, don't overwrite it
shopt -s histappend

# Determine the original user's login name
if [ -n "$SUDO_USER" ]; then
    login_name="$SUDO_USER"
elif [ -n "$LOGNAME" ] && [ "$LOGNAME" != "root" ]; then
    login_name="$LOGNAME"
else
    login_name="$(stat -c %U $(tty) 2>/dev/null)"
fi

# Set the terminal title based on the below template
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
# Ensures history is written after every command
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Simple backup solution
BASH_HISTCOUNT=$(cat ~/.bash_history | wc -l)
BASH_HISTCOUNT_BACKUP=$(if test -f ~/.bash_history.backup; then cat ~/.bash_history.backup | wc -l; else echo 0; fi;)
# -ge to avoid checking with -lt / diff
if [ $BASH_HISTCOUNT -ge $BASH_HISTCOUNT_BACKUP ]; then
    cp -f ~/.bash_history ~/.bash_history.backup
else
    echo "Warning, your ~/.bash_history line count is lower than of ~/.bash_history.backup!"
fi;


#####################
# Bash completion   #
#####################
if test -f /etc/profile.d/bash_completion.sh; then
    . /etc/profile.d/bash_completion.sh
fi;


#####################
# Custom bashrc     #
#####################

# Use to override existing bashrc changes wo affecting the default
if test -f $HOME/.bash/bashrc.custom; then
    . $HOME/.bash/bashrc.custom
fi;
