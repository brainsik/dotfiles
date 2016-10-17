#!/bin/bash

fynd() {
    find . -iname '*'$1'*'
}

# global aliases
alias rmpyc='if ! [[ $(pwd) = $HOME ]]; then find . -name \*.pyc -delete; find . -name __pycache__ -delete; fi'
alias rmorig='find . -name \*.orig | xargs rm'
alias egrep='egrep --color=auto --line-buffered'
alias grep='egrep'

case "$OSNAME" in
    Linux)
        # enable color support of ls and also add handy aliases
        if [[ -x /usr/bin/dircolors ]]; then
            test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
            alias ls='ls --color=auto'
        fi
        alias l='ls -oh'
        alias ll='ls -lha'
        # Add an "alert" alias for long running commands.  Use like so:
        #   sleep 10; alert
        alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
        # restore sanity
        alias ack='ack-grep'
        # typo repair!
        alias sudo-s='sudo -s'
        # sysop aliases
        alias aptup='sudo apt-get update && sudo apt-get dist-upgrade'
        alias cdignore='cd /etc/logcheck/ignore.d.server'
        alias pgsu='sudo -H -u postgres'
        alias ipt='sudo iptables'
        alias nat='sudo iptables -t nat'
        alias showdrives="dmesg | grep -E 'sd[abcd]' | grep -E '[TG]i?B'"
        alias reboot='history -w; sudo reboot'
    ;;

    Darwin)
        # color me ls
        alias ls='/bin/ls -Ghkv'
        alias l='ls -Ghkov'
        alias ll='l -Al'
        alias lld='ll -dl'
        # sysops
        alias sshadd="ssh-add -D;ssh-add ~/.ssh/id_{ed25519,rsa}"
        # open -a
        alias firefox='open -n -a Firefox --args'
        # deep path apps
        alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'
        #alias firefox='export -n DYLD_LIBRARY_PATH ; /Applications/Firefox.app/Contents/MacOS/firefox-bin'
        # OS X system apps
        alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
        alias lsregister='/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -r -domain local -domain system -domain user'
        alias dnsflush='dscacheutil -flushcache'
        # fake apps
        alias sd2toaiff='sox -t raw -r 44100 -w -s -c 2'
        alias dos2unix='perl -015 -l12 -pe "" -i'
        alias mounthalo='/Applications/Toast\ Titanium.app/Contents/MacOS/ToastImageMounter /Volumes/Users/brainsik/Documents/Halo\ Universal\ No\ CD.iso -imagekey blocksize=2048'
        # default switches for apps
        alias cdda2wav='cdda2wav -x -paranoia -L 0'
        alias madplay='madplay -v --tty-control'
        # dev
        gittouch() {
            for file in `git status | grep ': ' | perl -ne 'chomp; m/[^:]+: *(.+)/; print "$1\n";'`; do
                touch $file
            done
        }
        alias gitpull="git stash && git pull --rebase && git stash pop"
    ;;

    OpenBSD)
        alias l='ls -lh'
    ;;
    *)
        echo "Did not recognize OS '$OSNAME'; OS specific aliases not set."
    ;;
esac
