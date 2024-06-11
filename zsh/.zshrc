#
# Executes commands at the start of an interactive session.
#

# HACK: Disable shellcheck for zsh (not supported)
# shellcheck shell=sh
# shellcheck disable=all

#
# Zim
#

source $HOME/.zshrc_zim
export HISTORY_SUBSTRING_SEARCH_PREFIXED=yep

#
# Zsh / Shell
#

# Save a lot of command history
HISTSIZE=110000
SAVEHIST=100000

export EDITOR=vim
export VISUAL=$EDITOR

export MANWIDTH=80

if [[ -z "$BROWSER" && "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Starship
#

if whence starship >/dev/null; then
  eval "$(starship init zsh)"
fi

#
# Secretive SecretAgent
#

if [[ -d $HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent ]]; then
  export SSH_AUTH_SOCK="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"
fi

#
# PAGER
#

# Default to less.
export PAGER=less
export MANPAGER=$PAGER

# Prefer bat (but not for `man`).
if (( $#commands[(i)bat(|cat)] )); then
  export PAGER=$commands[(i)bat(|cat)]
  export BAT_THEME='Dracula'
fi

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X to enable it.
if [[ -z "$LESS" ]]; then
  export LESS='-g -i -M -R -S -w -X -z-4'
fi

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

#
# gpg-agent
#

# https://linux.die.net/man/1/gpg-agent
GPG_TTY=$(tty); export GPG_TTY

#
# ls
#

# `l` is in ~/bin
if whence -w l | grep alias >/dev/null; then
  unalias l
fi

if whence lsd >/dev/null; then
  alias ll='l -A'
  alias la='l -a'
  alias lo='l --blocks permission,user,size,date,name'
else
  alias lr='l -R'          # Lists human readable sizes, recursively.
  alias la='l -A'          # Lists human readable sizes, hidden files.
  alias lm='la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
  alias lx='l -XB'         # Lists sorted by extension (GNU only).
  alias lk='l -Sr'         # Lists sorted by size, largest last.
  alias lt='l -tr'         # Lists sorted by date, most recent last.
  alias lc='lt -c'         # Lists sorted by date, most recent last, shows change time.
  alias lu='lt -u'         # Lists sorted by date, most recent last, shows access time.

  alias ll='ls -lAh'       # Longer.
  alias lll='ls -lOAhe'    # Longest.

  alias l1='ls -1'         # Single column.
  alias l1a='ls -1A'       # Single column, hidden files.
fi

#
# git
#

alias gitnp='git --no-pager'
alias gitlanded='git checkout master && git pull && gitprune'

#
# mosh / et
#

# Prevent mosh from fully breaking scrolling since it uses the terminal alternative screen
alias mosh='mosh --no-init'

# Disable et telemetry
export ET_NO_TELEMETRY=1

#
# tar
#

alias tarnm='tar --no-mac-metadata --no-xattrs'

#
# terraform
#

alias tf=terraform

#
# macOS
#

if [[ "$OSTYPE" == darwin* ]]; then
  alias dnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
  alias firefox='/Applications/Firefox.app/Contents/MacOS/firefox'
  if ! whence tailscale >/dev/null; then
    alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
  fi
fi

#
# finale
#

# The dream of the 90's.
mesg y  # for a good time, call
uptime  # awareness
