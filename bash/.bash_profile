# Loaded first and only for a login shell

if [[ "${BASH-no}" != "no" ]]; then
    [[ -r /etc/bashrc ]] && . /etc/bashrc
fi
source ~/.bashrc

# make less more friendly for non-text input files, see lesspipe(1)
lesspipe=$(command -v lesspipe || command -v lesspipe.sh)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"
# prevent creation of ~/.lesshst
export LESSHISTFILE="-"

# experience
export EDITOR="vim"
export VISUAL="$EDITOR"
export MANWIDTH=80
if [[ "$OSNAME" = "Darwin" ]]; then  # color ls
    export CLICOLOR=yes
    export LSCOLORS="ExfxcxdxbxEgEdabagacad"
fi
export HOMEBREW_NO_ANALYTICS=1

# load additional profiles
for profile in ~/.bash_profile-*; do
    # skip any encrypted files
    [[ "$(head -c 9 $profile)" = "GITCRYPT" ]] && continue
    source $profile
done

# add SSH keys if they aren't in the agent
if [[ "$OSNAME" = "Darwin" ]] && [[ -s ~/.ssh/id_ed25519 ]]; then
    if [[ $(ssh-add -l) =~ "no identities" ]]; then
        ssh-add ~/.ssh/id_{ed25519,rsa}
    fi
fi

# https://github.com/keybase/keybase-issues/issues/1712#issuecomment-141226705
export GPG_TTY=$(tty)

# these often get set with root perms which jacks shit up
stat="stat -f %u"  # BSD
[[ "$OSNAME" = "Linux" ]] && stat="stat -c %u"
if [[ "$USER" == "brainsik" ]]; then
    for file in $HOME/.bash_history $HOME/.viminfo; do
        if [[ -e $file ]] && [[ $($stat $file) != "$UID" ]]; then
            echo "!! Bad owner for $file"
        fi
    done
fi

# for a good time, call
mesg y
# curiousness
uptime
