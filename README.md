## Linux

This assumes a remote host where we don't need the encrypted files.

```sh
sudo apt install git stow zsh
git clone git@github.com:brainsik/dotfiles.git .dotfiles
chsh -s $(which zsh)
bin/setup-shell
```

Logout and login.
