<!-- rumdl-disable MD041 -->
## Linux

This assumes a remote shell running bash where we don't need the encrypted
files.

```sh
sudo apt install git stow zsh
git clone https://github.com/brainsik/dotfiles.git .dotfiles
cd .dotfiles
./stow
cd ..
chsh -s $(which zsh)
bin/setup-shell
```

Logout and login.
