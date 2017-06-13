#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update apt's source list file
# Environment: FUNCTION

if [ "${skip_07sourceslist:=0}" -eq 1 ]
then
    echo 'INFO: Skip update sources.list'
    exit 0
fi

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi


RETCODE=0


version=`get_debian_version`

case "$version" in
    lenny)
        sources='config/sources.list.lenny'
        ;;
    squeeze)
        sources='config/sources.list.squeeze'
        ;;
    wheezy)
        sources='config/sources.list.wheezy'
        ;;
    *)
        echo 'ERROR: Unsupport debian version' >&2
        exit 1
        ;;
esac

echo 'Update apt sources.list...'
backup_etc_file /etc/apt/sources.list

cp -f "$sources" /etc/apt/sources.list
check_exit_restore /etc/apt/sourecs.list 'ERROR: Update /etc/apt/sources.list error!'

cat config/key.hw | apt-key add -
aptitude -yy update
