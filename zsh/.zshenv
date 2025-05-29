# Executes commands before login (zprofile) and interactive (zshrc). Needed to
# make executables like `mosh-server` available to the shell pre-login.

# HACK: Disable shellcheck for zsh (not supported)
# shellcheck shell=sh
# shellcheck disable=all

#
# Homebrew
#

# Export shell environment variables
for homebrew_prefix in /opt/homebrew /home/linuxbrew/.linuxbrew; do
  if [[ -x "$homebrew_prefix/bin/brew" ]]; then
    eval "$($homebrew_prefix/bin/brew shellenv)"
    break
  fi
done
