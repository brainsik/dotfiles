#
# Executes commands at login pre-zshrc.
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='vim'
export VISUAL=$EDITOR
export PAGER='less'
#if [[ "$OSTYPE" == darwin* ]]; then
#  export GIT_EDITOR="subl -n -w"
#fi

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Man
#

export MANWIDTH=80

if [[ -z "$MANPATH" ]] && whence manpath >/dev/null; then
    export MANPATH=$(manpath)
fi
export MANPATH="$HOME/man:$HOME/.local/man:$HOME/usr/man:$MANPATH"

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

#
# Node
#

[[ -d /usr/local/share/npm/bin ]] && path=(
  /usr/local/share/npm/bin
  $path
)

#
# Homebrew
#

export HOMEBREW_NO_ANALYTICS=1

# Export shell environment variables
for homebrew_prefix in /opt/homebrew /usr/local; do
  if [[ -x $homebrew_prefix/bin/brew ]]; then
    eval $($homebrew_prefix/bin/brew shellenv)
    break
  fi
done

if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
    fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi

#
# Golang
#

export GOPATH="$HOME/src/go"
path=(
  $GOPATH/bin
  $path
)

#
# Rust
#

[[ -d $HOME/.cargo/bin ]] && path=(
  $HOME/.cargo/bin
  $path
)

#
# Direnv
#

if whence direnv >/dev/null; then
  eval "$(direnv hook zsh)"
fi


#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Final directories Zsh searches for programs.
path=(
  $HOME/bin
  $HOME/.local/bin
  $HOME/usr/bin
  $path
)
