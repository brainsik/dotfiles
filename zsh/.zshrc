#
# Executes commands at the start of an interactive session.
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f $HOME/.p10k.zsh ]] && source "$HOME/.p10k.zsh"

# Save a lot of command history
HISTSIZE=110000
SAVEHIST=100000

# https://github.com/keybase/keybase-issues/issues/1712#issuecomment-141226705
GPG_TTY=$(tty); export GPG_TTY

#
# ls
#

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

#
# Git
#

alias gitnp='git --no-pager'
alias gitlanded='git checkout master && git pull && gitprune'

#
# Misc aliases
#

if [[ "$OSTYPE" == darwin* ]]; then
  alias dnsflush='dscacheutil -flushcache'
fi

# Finale
mesg y  # for a good time, call
uptime  # awareness
