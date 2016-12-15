#!/bin/bash
set -eo pipefail

# Start with all packages
PACKAGES=$(ls -1d * | grep -Ev 'stow.sh')
 
# Drop Darwin only packages
if [[ $(uname -s) != "Darwin" ]]; then
    echo $PACKAGES | grep -Ev 'homebrew'
    PACKAGES=$(echo $PACKAGES | sed -e 's/homebrew//')
fi

# Drop encrypted package if unsupported
if ! command -v git-crypt >/dev/null; then
    echo "- Skipping encrypted files"
    PACKAGES=$(echo $PACKAGES | sed -e 's/_encrypted//')
fi

# Drop SSH stuff if we're on host with keys already
if [[ -f ~/.ssh/id_ed25519.pub ]]; then
    echo "- Skipping ssh (keys exist)"
    PACKAGES=$(echo $PACKAGES | sed -e 's/ssh//')
fi

stow $* $PACKAGES
