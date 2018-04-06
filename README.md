# Russley's Dotfiles

My dotfiles for SSH'd development.

![Screenshot](screenshot.png)

## Installing

- Install zsh, vim, tmux
- [Install Antigen](https://github.com/zsh-users/antigen#installation)
- [Install Powerline Fonts](https://github.com/powerline/fonts/archive/master.zip)
- [Install Dracula Theme](https://gist.github.com/russleyshaw/4ce43f3b3c0d68ac67fe69eb3a375a4d)

```bash
# Copy files
cp ./zshrc ~/.zshrc
cp ./vimrc ~/.vimrc
cp ./tmux.conf ~/.tmux.conf

# Install VIM plugins
vim +PluginInstall +qall
```

## Updating

```bash
cp ~/.zshrc ./zshrc
cp ~/.vimrc ./vimrc
cp ~/.tmux.conf ./tmux.conf
```
