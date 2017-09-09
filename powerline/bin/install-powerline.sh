#!/bin/bash
set -exo pipefail

# Default to system Python to prevent weird stuff happening.
use_system_pyenv() {
    # skip if pyenv isn't installed
    command -v pyenv >/dev/null || return

    pyenv_global=$(pyenv global)
    restore_pyenv_global() { pyenv global "$pyenv_global"; }
    trap restore_pyenv_global EXIT
    pyenv global system
    export PYENV_VERSION=system
}

# Install pip to the system (we'll clean it up later).
install_pip() {
    python -m ensurepip --user
    pip install --upgrade --user pip
}

# Install powerline.
install_powerline() {
    pip install --upgrade --user powerline-status

    # Install patched powerline-status module.
    tmpdir=$(mktemp -d)
    pushd "$tmpdir"
    git clone https://github.com/brainsik/powerline-gitstatus.git
    pip install --upgrade --user ./powerline-gitstatus
    popd
    rm -rf "$tmpdir"
}

# Remove system pip install so we don't accidentally use it.
remove_pip() {
    pip uninstall -y pip
}

# -- main --

# We do this manually to handle the case where you've uninstalled the system
# powerline and are moving to a local installation.
for pid in $(pgrep -u $USER -f powerline-daemon); do
    kill "$pid"
done

if [[ $(uname -s) = Darwin ]]; then
    use_system_pyenv
    install_pip
    install_powerline
    "$HOME/Library/Python/2.7/bin/powerline-daemon"
    remove_pip
else
    install_powerline
    "$HOME/.local/bin/powerline-daemon"
fi

set +x
if command -v powerline | grep '/usr/bin/powerline'; then
    echo "Your PATH is finding a system-wide powerline install. Either you need"
    echo "to logout and in again to pick up the local PATH or you need to"
    echo "update your shell to have the local bin directory earlier on the PATH."
fi
