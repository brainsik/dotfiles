#!/bin/bash
set -exo pipefail

# Default to system Python to prevent weird stuff happening.
use_system_pyenv() {
    pyenv_global=$(pyenv global)
    restore_pyenv_global() { pyenv global $pyenv_global; }
    trap restore_pyenv_global EXIT
    pyenv global system
    export PYENV_VERSION=system
}

# Install pip to the system (we'll clean it up later).
install_pip() {
    tempd=$(mktemp -d)  # if this isn't cleaned up, meh
    pushd $tempd >/dev/null
    curl -O --progress https://bootstrap.pypa.io/get-pip.py
    sudo -H python get-pip.py
    popd >/dev/null
    rm -rf $tempd
}

# Install powerline.
install_powerline() {
    pip install --upgrade --user powerline-status
    pip install --upgrade --user powerline-gitstatus
}

# Remove system pip install so we don't accidentally use it.
remove_pip() {
    for pkg in pip wheel; do
        pkg_path=$(dirname $(python -c 'import '$pkg'; print('$pkg'.__file__)'))
        # ensure we're deleting something sane
        [[ $pkg_path =~ site-packages ]] || exit 1
        sudo rm -r $pkg_path*
    done
    sudo rm /usr/local/bin/{pip,wheel}*
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
