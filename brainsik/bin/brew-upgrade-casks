#!/usr/bin/env bash
set -euo pipefail

brew update

for cask in $(brew cask list); do
    current=$(brew cask info "$cask" | perl -ne 'if (m|/usr/local/Caskroom/\w+/(\S+)|) { print "$1\n"; }')
    latest=$(brew cask info "$cask" | head -n1 | awk '{print $2}')
    if [[ $current != "$latest" ]]; then
        echo "🤡 Upgrading $cask from $current to $latest:"
        brew cask reinstall "$cask"
    fi
done
