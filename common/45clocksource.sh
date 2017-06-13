#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update clock source
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

echo "Change clocksource to tsc,hpet,jiffies"
CLOCK_SOURCE_DIR="/sys/devices/system/clocksource/clocksource0"

if [ -f "$CLOCK_SOURCE_DIR/available_clocksource" ]
then
    clocks=''

    cpu_flags=0
    for flag in rdtscp constant_tsc nonstop_tsc
    do
        [ `grep -m1 flags /proc/cpuinfo | grep -c $flag` -ne 0 ] && cpu_flags=`expr $cpu_flags + 1`
    done
    
    tsc_aval=0
    [ `grep -c tsc $CLOCK_SOURCE_DIR/available_clocksource` -ne 0 ] && tsc_aval=1
    
    [ $cpu_flags -eq 3 -a $tsc_aval -eq 1 ] && clocks='tsc'


    if [ -z "$clocks" ]
    then
        clocksources=`cat $CLOCK_SOURCE_DIR/available_clocksource`
        case "$clocksources" in
            *hpet*)
                clocks='hpet'
                ;;
            *jiffies*)
                clocks='jiffies'
                ;;
        #    *acpi_pm*)
        #        clocks='acpi_pm'
        #        ;;
            *)
                clocks=''
                ;;
        esac
    fi
    
    if [ -n "$clocks" ]
    then
        echo "$clocks" > $CLOCK_SOURCE_DIR/current_clocksource
        if [ -e "/etc/default/grub" ]
        then
            backup_etc_file /etc/default/grub
            sed -i "s/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"clocksource=${clocks}\"/" /etc/default/grub && update-grub
        else
            backup_etc_file /boot/grub/menu.lst
            sed -i "/^# kopt=root=.* ro$/s/$/ clocksource=${clocks}/" /boot/grub/menu.lst && update-grub
        fi
    else
        echo "[1;33mavailable_clocksource is not contain hpet or jiffies or tsc[00m"
    fi

    echo "Current clocksource: [1;32m`cat $CLOCK_SOURCE_DIR/current_clocksource`[00m"

else
    echo "Available clocksource file isn't exist!"
fi
