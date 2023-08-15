#
# Executes commands at login pre-zshrc.
#

# HACK: Disable shellcheck for zsh (not supported)
# shellcheck shell=sh
# shellcheck disable=all

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Man
#

if [[ -z "$MANPATH" ]] && whence manpath >/dev/null; then
    export MANPATH=$(manpath)
fi
export MANPATH="$HOME/man:$HOME/.local/man:$HOME/usr/man:$MANPATH"

#
# Homebrew
#

# Export shell environment variables
for homebrew_prefix in /opt/homebrew /usr/local; do
  if [[ -x "$homebrew_prefix/bin/brew" ]]; then
    eval "$($homebrew_prefix/bin/brew shellenv)"
    break
  fi
done

if [[ -d /opt/homebrew/share/zsh/site-functions ]]; then
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
fi

# Set the list of directories that Zsh searches for programs.
path=(
  /opt/homebrew/{,s}bin(N)
  $path
)

#
# Node
#

[[ -d /usr/local/share/npm/bin ]] && path=(
  /usr/local/share/npm/bin
  $path
)

#
# Golang
#

if [[ -d "$HOME/src/go" ]]; then
  export GOPATH="$HOME/src/go"
  path=(
    $GOPATH/bin
    $path
  )
fi

#
# Rust
#

if [[ -s "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

#
# Terraform
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

# Set the first directories that Zsh searches for programs.
path=(
  $HOME/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)
