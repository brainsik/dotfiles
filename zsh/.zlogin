# HACK: Disable shellcheck for zsh (not supported)
# shellcheck shell=sh
# shellcheck disable=all

if [[ -z "$SUDO_USER" ]]; then
  uptime  # awareness
fi
