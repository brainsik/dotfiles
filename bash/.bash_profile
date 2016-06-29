# Loaded first and only for a login shell

# we key off the OS name to decide what to load
export OSNAME=$(uname -s)
case "$OSNAME" in
    Darwin|Linux|OpenBSD) ;;
    *) echo "Did not recognize OS '$OSNAME'; some things will not be set!" ;;
esac

unset ISVIRTUAL
if [[ "$OSNAME" = "linux" ]] && command -v lspci >/dev/null; then
    if lspci | egrep -i 'qemu|virtualbox|vmware' >/dev/null; then
        export ISVIRTUAL=yes
    fi
fi

source ~/.bash_paths

if [[ "${BASH-no}" != "no" ]]; then
    [[ -r /etc/bashrc ]] && . /etc/bashrc
fi
source ~/.bashrc

# make less more friendly for non-text input files, see lesspipe(1)
lesspipe=$(command -v lesspipe || command -v lesspipe.sh)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# experience
export EDITOR="vim"
export VISUAL="$EDITOR"
export MANWIDTH=80

# load additional profiles
for profile in ~/.bash_profile-*; do
    source $profile
done

# add SSH keys if they aren't in the agent
if [[ "$OSNAME" = "Darwin" ]] && [[ -s ~/.ssh/id_ed25519 ]]; then
    if [[ $(ssh-add -l) =~ "no identities" ]]; then
        ssh-add ~/.ssh/id_{ed25519,rsa}
    fi
fi

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
