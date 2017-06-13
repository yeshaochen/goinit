#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Setting vim
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "Set default editor to vi"
update-alternatives --set editor /usr/bin/vim.basic
check_exit

echo "Add vimrc.local ..."
cp -f config/vimrc.local /etc/vim/vimrc.local
check_exit
