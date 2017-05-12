#!/bin/bash
set -exo pipefail

# Default to system Python to prevent weird stuff happening.
use_system_pyenv() {
    # skip if pyenv isn't installed
    command -v pyenv >/dev/null || return

    pyenv_global=$(pyenv global)
    restore_pyenv_global() { pyenv global $pyenv_global; }
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
    pip install --upgrade --user powerline-gitstatus
}

# Remove system pip install so we don't accidentally use it.
remove_pip() {
    pip uninstall -y pip
}

# -- main --

if [[ $(uname -s) = Darwin ]]; then
    use_system_pyenv
    install_pip
    install_powerline
    remove_pip
else
    install_powerline
fi
