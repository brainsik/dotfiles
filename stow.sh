#!/bin/bash
set -eo pipefail

# Start with all packages
PACKAGES=$(ls -1d * | grep -Ev 'stow.sh' | perl -pe 's/\n/ /g;')
echo "PACKAGES=$PACKAGES"
 
# Drop Darwin only packages
if [[ $(uname -s) != "Darwin" ]]; then
    PACKAGES=$(echo $PACKAGES | perl -pe 's/ ?homebrew//')
fi
echo "PACKAGES=$PACKAGES"

# Drop encrypted package if unsupported
if ! command -v git-crypt >/dev/null; then
    echo "- Skipping encrypted files"
    PACKAGES=$(echo $PACKAGES | perl -pe 's/ ?_encrypted//')
fi
echo "PACKAGES=$PACKAGES"

# Drop SSH stuff if we're on host with keys already
if test -f ~/.ssh/id_ed25519.pub && ! test -L ~/.ssh/id_ed25519.pub; then
    echo "- Skipping ssh (keys exist)"
    PACKAGES=$(echo $PACKAGES | perl -pe 's/ ?ssh//')
fi
echo "PACKAGES=$PACKAGES"

stow $* $PACKAGES
