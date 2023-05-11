#!/bin/bash

sudo apt-get update -y
sudo apt-get install zsh -y

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
 
# Font
## https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS NF Regular.ttf

# powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

sudo reboot

