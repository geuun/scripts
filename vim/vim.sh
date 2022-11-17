#!/bin/bash


git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# config 복사
cd vim

cp ./.vimrc ~/.vimrc

# setting jellybeans
mkdir -p ~/.vim/colors
cd ~/.vim/colors
curl -O https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim

# 적용작업 필요
# vim ~/.vimrc
# :source %
# :PluginInstall

echo "아래 작업을 수행하세요."
echo "$ vim ~/.vimrc "
echo "$ :source %"
echo "$ :PluginInstall"
