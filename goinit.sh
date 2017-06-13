#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

project=1
if [ -z "${projectscript}" ] || [ -z "${projectscript_url}" ]
then
    echo "INFO:[1;33m Running without project code.[00m Otherwise you need to export projectscript projectscript_url."
    project=0
fi

echo "[`date +'%F %T'`] INFO [1;32mScript start[00m"

####### don't change any variable below ########
version='0.95'
user=`whoami`
workdir=`pwd`
checkfs=1
#set var "download" as 1 will download tar file every time. Don't change it. It can be set as 1 by using '-reset-file' option.
download=0

#set root password, default is 1 (must set password)
setpasswd=1

#default isp string
isp=''

optionstr="$@"

##### variable for '-s startscript' option #####
startrun=1

commscript_dir="${workdir}/${commscript%%.*}"

if [ "$project" -eq 1 ]
then
    projectscript_dir="${workdir}/${projectscript%%.*}"
fi


###### functions ######
#check os arch
checkarch(){
    local bit32='i386'
    local bit64='amd64'
    local res=`uname -m`
    case $res in
        i386|i486|i586|i686|x86)
            ARCH="${bit32}"
            ;;
        x86_64|amd64)
            ARCH="${bit64}"
            ;;
        *)
            echo "Unknown os arch $res"
            ARCH="$res"
            ;;
    esac
    export ARCH
}

#check script source
checksource(){
    local url="$1"
    local file="$2"
    if [ -z "$url" ] || [ -z "$file" ]
    then
        echo 'Usage: checksource url file'
        exit 1
    fi

    if [ "$download" -eq 0 ]
    then
        if [ -f "$file" ]
        then
            tar zfx "$file"
        else
            if ! ( wget -q $url -O "$file" && tar zfx "$file"; )
            then
                echo "Download $file error" >&2
                exit 3
            fi
        fi
    else
        if ! ( wget -q $url -O "$file" && tar zfx "$file"; )
        then
            echo "Download $file error" >&2
            exit 3
        fi
    fi
}

#check filesystem
checkfilesystem(){
    if [ "$checkfs" -eq 1 ]
    then
        local roottype=`mount | awk '$3=="/"{print $5}'`
        local hometype=`mount | awk '$3=="/home"{print $5}'`
        case "$roottype" in
            *ext3*|*ext4*)
                case "${hometype:=$roottype}" in
                    *ext3*|*ext4*)
                        :
                        ;;
                    *)
                        echo "Error:[1;31mExt3 or Ext4 file system is required[00m" >&2
                        echo " ========== Runing without checking fs type 'sh ${myname:-$0} -ignore-fs $optionstr' ==========" >&2
                        exit 5
                        ;;
                esac
                ;;
            *)
                echo "Error:[1;31mExt3 or Ext4 file system is required[00m" >&2
                echo " ========== Runing without checking fs type 'sh ${myname:-$0} -ignore-fs $optionstr' ==========" >&2
                exit 5
                ;;
        esac
    fi
}

#run the precheck script
precheck(){
    local dir="$1"
    local currendir=`pwd`
    shift

    if [ ! -d "$dir" ]
    then
        echo "No such directory: $dir" >&2
        exit 6
    fi

    trap "echo ' ========== [1;31m $dir/precheck script error [00m ========== '" exit
    if [ -e "$dir/precheck" ]
    then
        cd "$dir"
        . "$dir/precheck"
    fi
    cd "$currendir" 
    trap '' exit
}

#run all script
run(){
    local scriptdir="$1"
    local installscript="$scriptdir/[0-9][0-9]*"

    if [ "$#" -ge 1 ]
    then
        shift
    fi

    cd "$scriptdir"

    if [ -e "$scriptdir/function" ]
    then
        export FUNCTION="${scriptdir}/function"
    fi

    for script in $installscript
    do
        if [ "$startscript" = "$script" ]
        then
            startrun=1
        fi
        
        if [ "$startrun" -ne 1 ]
        then
            continue
        fi

        if [ ! -r "$script" ]
        then
            echo "$script is unreadable" >&2
            RETCODE=1
            break
        fi

        echo "[1;32mRUN: $script [00m"
        sh "$script"
        RETCODE=$?
        if [ "$RETCODE" -ne 0 ]
        then
            break
        fi
    done

    if [ "${RETCODE:=0}" -ne 0 ]
    then
        echo " ========== [1;31m Something wrong for initscript $script . Please Check it [00m ========== " >&2
        script=`echo "$script" | sed "s#${workdir}/##"`
        if [ "$checkfs" -eq 0 ]
        then
            echo " ========== Retry with 'sh ${myname:-$0} -ignore-fs -s $script $@' ==========" >&2
        else
            echo " ========== Retry with 'sh ${myname:-$0} -s $script $@' ==========" >&2
        fi
        exit $RETCODE
    fi
    cd "${workdir}"
}


#check user
if [ "$user" != "root" ]
then
    echo "[1;31mMust be run with root user[00m" >&2
    exit 1
fi


################ check options #############
usage="Usage: $0 [-s startscript] [-ignore-fs] [-isp {tel|cnc|edu|bgp}] [-skip-setpasswd] [-reset-file] {options}..."
while [ $# -ge 1 ]
do
    if [ -n "$1" ]
    then
        case "$1" in
            -s)
                if [ $# -le 1 ]
                then
                    echo "$usage"
                    exit 2
                fi
                shift
                startscript="${workdir}/$1"
                startrun=0
                ;;
            -ignore-fs)
                checkfs=0
                ;;
            -reset-file)
                download=1
                ;;
            -isp)
                shift
                isp="$1"
                ;;
            -skip-setpasswd)
                setpasswd=0
                ;;
            -h|--help)
                echo "$usage"
                exit
                ;;
            *)
                if [ -z "$opt" ]
                then
                    opt="$1"
                else
                    opt="$opt $1"
                fi 
                ;;
        esac
    fi
    shift
done


if [ -n "$opt" ]
then
    set - $opt
fi

export isp setpasswd

#check file system type
checkfilesystem

#check os arch
checkarch
######### end of options check ###########


########### script start #################
if [ "$project" -eq 1 ]
then
    case "$startscript" in
        $projectscript_dir*)
            checksource "${projectscript_url}" "${projectscript}"
            precheck "${projectscript_dir}" "$@"
            run "${projectscript_dir}" "$@"
            ;;
        *)
            checksource "${commscript_url}" "${commscript}"
            checksource "${projectscript_url}" "${projectscript}"
            precheck "${commscript_dir}" "$@"
            precheck "${projectscript_dir}" "$@"
            run "${commscript_dir}" "$@"
            run "${projectscript_dir}" "$@"
            ;;
    esac
else
    checksource "${commscript_url}" "${commscript}"
    precheck "${commscript_dir}" "$@"
    run "${commscript_dir}" "$@"
fi
    
if [ "$startrun" -eq 0 ]
then
    echo "Can not find the $startscript file" >&2
    exit 7
fi

if [ "${RETCODE:-1}" -eq 0 ]
then
    echo "[`date +'%F %T'`] INFO [1;32mScript End [00m"
    echo " ========== [1;32m Everything done [00m ========== "
    exit 0
fi
