#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

#Install needed software

RETCODE=0
pkg_list=`grep -v '^ *#\|^ *$' config/install`
if [ -n "$pkg_list" ]
then
    echo "Install "$pkg_list"..."
    aptitude -yy --without-recommends install $pkg_list
    RETCODE=$?
else
    echo 'Warning: None pkgs need to be installed' >&2
fi

exit "$RETCODE"
