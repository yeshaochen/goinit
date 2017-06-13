#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "ln /bin/sh -> bash"
if [ -f "/bin/dash" ]
then
    echo "dash    dash/sh boolean false" | debconf-set-selections && dpkg-reconfigure --frontend=noninteractive dash
else
    ln -sf bash /bin/sh
fi
check_exit 'ln /bin/bash /bin/sh error!'
