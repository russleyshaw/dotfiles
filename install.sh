#!/bin/bash

echo "Copying files..."
cp ./zshrc ~/.zshrc
cp ./vimrc ~/.vimrc
cp ./tmux.conf ~/.tmux.conf

echo "Installing vim plugins..."
vim +PlugInstall +qall

echo "Installing Antigen..."
mkdir -p ~/.antigen
curl -L git.io/antigen > ~/.antigen/antigen.zsh
