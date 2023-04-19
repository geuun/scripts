#!/bin/bash	

read -p "Github User Name: " 	UserName
read -p "Github User Email: " 	UserEmail

git config --global user.name "${UserName}"
git config --global user.email "${UserEmail}"
git config --global core.editor "vim"
git config --global core.pager "cat"
git config --global init.defaultBranch main

# git 로그인 정보 저장
git config credential.helper store
