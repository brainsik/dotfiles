#!/bin/bash
set -o pipefail

# Start with all packages
PACKAGES=$(ls -1d * | grep -Ev 'stow.sh')
 
# Drop Darwin only packages
if [[ $(uname -s) != "Darwin" ]]; then
    echo $PACKAGES | grep -Ev 'homebrew'
    PACKAGES=$(echo $PACKAGES | sed -e 's/homebrew//')
fi

# Drop encrypted package if unsupported
if ! command -v git-crypt >/dev/null; then
    PACKAGES=$(echo $PACKAGES | sed -e 's/_encrypted//')
fi

stow $* $PACKAGES
