#!/bin/bash	

read -p "Github User Name: " 	UserName
read -p "Github User Email: " 	UserEmail

echo "${UserName}"
echo "${UserEmail}"

#git config --global user.name "${UserName}"
#git config --global user.email "${UserEmail}"
#git config --global core.editor "vim"
#git config --global core.pager "cat"
#git config --global init.defaultBranch main
