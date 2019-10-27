#
# Executes commands at the start of an interactive session.
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Save a lot of command history
HISTSIZE=110000
SAVEHIST=100000

# https://github.com/keybase/keybase-issues/issues/1712#issuecomment-141226705
GPG_TTY=$(tty); export GPG_TTY

#
# Git
#
alias gitnp='git --no-pager'
alias gitlanded='git checkout master && git pull && gitprune'

if whence hub >/dev/null; then
    eval "$(hub alias -s)"
fi

# finale
mesg y  # for a good time, call
uptime  # awareness
