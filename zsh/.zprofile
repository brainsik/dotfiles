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
# Snap
#

[[ -d /snap/bin ]] && path=(
  /snap/bin
  $path
)

#
# Homebrew
#

# Even though we do this in .zshenv, we need to do it again in .zprofile to
# ensure Homebrew is before paths like /usr/bin. On macOS, /etc/zprofile
# will eval `/usr/libexec/path_helper -s` which results in Homebrew coming
# after. This will fix things up.
for homebrew_prefix in /opt/homebrew /home/linuxbrew/.linuxbrew; do
  if [[ -x "$homebrew_prefix/bin/brew" ]]; then
    eval "$($homebrew_prefix/bin/brew shellenv)"
    break
  fi
done

if [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

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
# Lua
#

[[ -d "$HOME/.luarocks/bin" ]] && path=(
  "$HOME/.luarocks/bin"
  $path
)

#
# Node
#

[[ -d /usr/local/share/npm/bin ]] && path=(
  /usr/local/share/npm/bin
  $path
)

[[ -d "$HOME/.npm-global/bin" ]] && path=(
  "$HOME/.npm-global/bin"
  $path
)

if command -v nodenv >/dev/null; then
  eval "$(nodenv init -)"
fi

#
# Ruby
#

if command -v rbenv >/dev/null; then
  eval "$(rbenv init -)"
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
# OrbStack
#

if [[ -s ~/.orbstack/shell/init.zsh ]]; then
  # Added by OrbStack: command-line tools and integration
  source ~/.orbstack/shell/init.zsh 2>/dev/null || :
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
  $HOME/.local/bin
  /usr/local/{,s}bin(N)
  $path
)
