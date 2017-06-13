#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Remove packages and update system
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

RETCODE=0

pkg_list=`grep -v '^ *#\|^ *$' config/remove`
if [ -n "$pkg_list" ]
then
    aptitude -yy purge $pkg_list
    check_exit 'ERROR: Remove pkg in config/remove error!'
fi
    
aptitude -yy update && aptitude -yy upgrade && aptitude -yy dist-upgrade
