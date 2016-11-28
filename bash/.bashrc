# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

_source_if_exists() {
    if [[ -s $1 ]]; then
        if [[ "$TERM" = "xterm-256color" ]]; then
            if [[ -n "$2" ]]; then
                [[ "$2" != "quiet" ]] && echo "Loading $2 …"
            else
                echo "Loading $(basename $1) …"
            fi
        fi
        source $1
    else
        return 1
    fi
}

# we key off the OS name to decide what to load
export OSNAME=$(uname -s)
case "$OSNAME" in
    Darwin|Linux|OpenBSD) ;;
    *) echo "Did not recognize OS '$OSNAME'; some things will not be set!" ;;
esac

unset VIRTUALIZER
if [[ "$OSNAME" = "Linux" ]]; then
    if [[ -d /proc/xen ]]; then
        export VIRTUALIZER="Xen"
    elif [[ -d /proc/cpuinfo ]] && grep -i QEMU /proc/cpuinfo >/dev/null; then
        export VIRTUALIZER="QEMU"
    elif command -v lspci >/dev/null; then
        export VIRTUALIZER=$(lspci | egrep -io 'qemu|virtualbox|vmware|xen|parallels' | head -n1)
    fi
fi

source ~/.bash_paths


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=$HISTSIZE

# If set, and readline is being used, a user is given the opportunity to re-
# edit a failed history substitution.
shopt -s histreedit

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s globstar
fi

# If set, minor errors in the spelling of a directory component in a cd command
# will be corrected. The errors checked for are transposed characters, a
# missing character, and one character too many. If a correction is found, the
# corrected file name is printed, and the command proceeds. This option is only
# used by interactive shells.
shopt -s cdspell

# If set, and readline is being used, bash will not attempt to search
# the PATH for possible completions when completion is attempted on an empty
# line.
shopt -s no_empty_cmd_completion

_source_if_exists ~/.bash_prompt quiet
_source_if_exists ~/.bash_aliases quiet

# enable programmable completion features
if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
    _source_if_exists /opt/local/etc/bash_completion quiet
    _source_if_exists /usr/local/etc/bash_completion quiet
fi
