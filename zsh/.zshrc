#
# Executes commands at the start of an interactive session.
#

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
  # Support our own compiled gistatusd (e.g., arm64 macOS)
  [[ -x "$HOME/bin/gitstatusd" ]] && GITSTATUS_DAEMON="$HOME/bin/gitstatusd"

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

if whence lsd >/dev/null; then
  alias l='lsd -l'
  alias ll='lsd -Al'
  alias lo='ls -oh'         # Lists human readable sizes.
else
  alias l='ls -oh'         # Lists human readable sizes.
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
# terraform
#

alias tf=terraform

#
# macOS
#

if [[ "$OSTYPE" == darwin* ]]; then
  alias dnsflush='dscacheutil -flushcache'
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
