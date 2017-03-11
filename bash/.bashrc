# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

[[ -f $HOME/.bash_library ]] && . $HOME/.bash_library

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=$HISTSIZE

# If set, and readline is being used, a user is given the opportunity to re-edit
# a failed history substitution.
shopt -s histreedit

# If set, bash attempts to save all lines of a multiple- line command in the
# same history entry. This allows easy re-editing of multi-line commands.
shopt -s cmdhist

# check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will match all
# files and zero or more directories and subdirectories.
if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    shopt -s globstar
fi

# If set, minor errors in the spelling of a directory component in a cd command
# will be corrected. The errors checked for are transposed characters, a missing
# character, and one character too many. If a correction is found, the corrected
# file name is printed, and the command proceeds. This option is only used by
# interactive shells.
shopt -s cdspell

# If set, and readline is being used, bash will not attempt to search the PATH
# for possible completions when completion is attempted on an empty line.
shopt -s no_empty_cmd_completion

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

_source_if_exists $HOME/.bash_aliases quiet
_source_if_exists $HOME/.bash_prompt quiet
_source_if_exists $HOME/.bash_local quiet
_source_if_exists $HOME/.bash_finale quiet
