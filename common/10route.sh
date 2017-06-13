#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update route table
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi


