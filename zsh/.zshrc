
#
# Executes commands at the start of an interactive session.
#

# HACK: Disable shellcheck for zsh (not supported)
# shellcheck shell=sh
# shellcheck disable=all

#
# Prezto
#

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi


#
# Shell prompt
#

# Starship
if whence starship >/dev/null; then
  eval "$(starship init zsh)"

# Powerlevel10k
else
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ -f $HOME/.p10k.zsh ]] && source "$HOME/.p10k.zsh"
fi

#
# Secretive SecretAgent
#

if [[ -d $HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent ]]; then
  export SSH_AUTH_SOCK=$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
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
unalias l
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
# tar
#
alias tarnm="tar --no-mac-metadata --no-xattrs"

#
# terraform
#

# Configure a Provider Plugin Cache
#   This directory must already exist before Terraform will cache plugins;
#   Terraform will not create the directory itself.
#   https://www.terraform.io/cli/config/config-file#provider-plugin-cache
export TF_PLUGIN_CACHE_DIR="$HOME/.cache/terraform"
if ! [[ -d $TF_PLUGIN_CACHE_DIR ]]; then
  mkdir -p $TF_PLUGIN_CACHE_DIR
fi

# Have tfenv use a local directory for config (instead of the place the binary
# is installed). This let's us drop a .dotfile to tell it to use gpg
# (instead of Keybase). For better or worse, this is also where the terraform
# versions will be installed.
export TFENV_CONFIG_DIR="$HOME/.tfenv"

alias tf=terraform

#
# macOS
#

if [[ "$OSTYPE" == darwin* ]]; then
  alias dnsflush='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
  alias firefox='/Applications/Firefox.app/Contents/MacOS/firefox-bin'
  alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
fi

#
# finale
#

# Save a lot of command history
HISTSIZE=110000
SAVEHIST=100000

# old school
mesg y  # for a good time, call
uptime  # awareness
