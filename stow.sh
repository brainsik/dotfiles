#!/bin/bash
set -eo pipefail
DEBUG () { false; }

if ! command -v stow >/dev/null; then
    echo '💾  Missing the stow command. Installing!'
    case $(uname -s) in
        Linux)
            sudo apt-get -qq update
            sudo apt-get -qq -y install stow ;;
        Darwin) brew install stow >/dev/null ;;
        *) echo "👽  Unrecognized OS." ;;
    esac
fi

# Ensure some directories already exist so we don't just get symlinks
mkdir -p ~/.config
mkdir -p ~/.vim
mkdir -p ~/bin
mkdir -p -m 0700 ~/.gnupg

# Start with all packages
PACKAGES=$(for f in *; do echo "$f"; done | grep -Ev 'stow.sh' | perl -pe 's/\n/ /g;')
DEBUG && echo "PACKAGES=$PACKAGES"

# Drop Darwin only packages
if [[ $(uname -s) != "Darwin" ]]; then
    PACKAGES=$(echo "$PACKAGES" | perl -pe 's/ ?macos//')
    PACKAGES=$(echo "$PACKAGES" | perl -pe 's/ ?homebrew//')
fi
DEBUG && echo "PACKAGES=$PACKAGES"

# Drop encrypted package if unsupported
if ! command -v git-crypt >/dev/null; then
    echo "- Skipping encrypted files"
    PACKAGES=$(echo "$PACKAGES" | perl -pe 's/ ?_encrypted//')
fi
DEBUG && echo "PACKAGES=$PACKAGES"

# Drop SSH stuff if we're on host with keys already
if test -f ~/.ssh/id_ed25519.pub && ! test -L ~/.ssh/id_ed25519.pub; then
    echo "- Skipping ssh (keys exist)"
    PACKAGES=$(echo "$PACKAGES" | perl -pe 's/ ?ssh//')
fi
DEBUG && echo "PACKAGES=$PACKAGES"

# shellcheck disable=SC2086
stow "$@" $PACKAGES
