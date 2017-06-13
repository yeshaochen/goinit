#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update fstab 
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi
        
echo "Update fstab..."
backup_etc_file /etc/fstab

perl -n -e 'print and next if (/^\s*#/);
$line = $_;
($device, $mountpoint, $fstype, $option, $checkopt) = split(/\s+/, $line, 5);
if ($mountpoint eq "/home" || $mountpoint eq "/tmp" || $mountpoint eq "/usr" || $mountpoint eq "/var" ) {
    $option =~ s/noatime//;
    $option .= ",noatime,nodiratime";
    $option =~ s/,,/,/g;
    print "$device\t$mountpoint\t$fstype\t$option\t$checkopt"
} else {
    print $line;
}
' /etc/fstab > /etc/fstab.new &&  mv /etc/fstab.new /etc/fstab
check_exit_restore /etc/fstab
