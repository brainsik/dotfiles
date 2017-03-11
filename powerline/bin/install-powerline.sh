#!/bin/bash
set -ex
cd $(mktemp -d)

# Default to system Python to prevent weird stuff happening.
pyenv global system
export PYENV_VERSION=system

# Install pip to the system (we'll clean it up later).
curl -O --progress https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py

# Install powerline.
pip install --upgrade --user powerline-status

# Cleanup system pip; we should never use it.
sudo rm -rf /Library/Python/2.7/site-packages/pip* /Library/Python/2.7/site-packages/wheel*
sudo rm /usr/local/bin/pip* /usr/local/bin/wheel
