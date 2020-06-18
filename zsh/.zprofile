#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
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
if [[ "$OSTYPE" == darwin* ]]; then
  export GIT_EDITOR="subl -n -w"
fi

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
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

# Set the list of directories that Zsh searches for programs.
path=(
  $HOME/bin
  $HOME/.local/bin
  $HOME/usr/bin
  /usr/local/{bin,sbin}
  $path
)

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


# Node
[[ -d /usr/local/share/npm/bin ]] && path=(
  /usr/local/share/npm/bin
  $path
)

# Golang
export GOPATH="$HOME/src/go"
path=(
  $GOPATH/bin
  $path
)

# Rust
[[ -d $HOME/.cargo/bin ]] && path=(
  $HOME/.cargo/bin
  $path
)


#
# Homebrew
#

export HOMEBREW_NO_ANALYTICS=1

# brew install zsh-completions
if [[ -d /usr/local/share/zsh-completions ]]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi
