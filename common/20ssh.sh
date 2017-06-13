#!/bin/sh
# Project: Goinit
# Version: V0.95
# Github: https://github.com/yeshaochen/goinit
# Description: Goinit is Linux system initialization automation tools.
# Author: yeshaochen
# Date: 2014-05-18

# Update opensshd config file
# Environment: FUNCTION

if [ -n "$FUNCTION" ]
then
    . "$FUNCTION"
else
    echo "export FUNCTION first" >&2
    exit 1
fi

RETCODE=0

echo "Changing sshd_config..."

sed -e 's/^Port/#&/' \
    -e 's/^Protocol/#&/' \
    -e 's/^PermitRootLogin/#&/' \
    -e 's/^PubkeyAuthentication/#&/' \
    -e 's/^AuthorizedKeysFile/#&/' \
    -e 's/^PasswordAuthentication/#&/' \
    -e 's/^ChallengeResponseAuthentication/#&/' \
    -e 's/^PermitEmptyPasswords/#&/' \
    -e 's/^UsePAM/#&/' \
    -e 's/^UseDNS/#&/' \
    -e 's/^AddressFamily/#&/' \
    -e 's@^Subsystem sftp /usr/lib/openssh/sftp-server@#&@' \
    /etc/ssh/sshd_config > /etc/ssh/sshd_config.new

RETCODE=$?

if [ "$RETCODE" -eq 0 ] && [ -f /etc/ssh/sshd_config.new ]
then
    cat <<_EOF >> /etc/ssh/sshd_config.new
Port 32200
Protocol 2
PermitRootLogin no
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PasswordAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
UsePAM no
UseDNS no
AddressFamily inet
Subsystem sftp /usr/lib/openssh/sftp-server
_EOF
    backup_etc_file /etc/ssh/sshd_config
    mv -f /etc/ssh/sshd_config.new /etc/ssh/sshd_config && /etc/init.d/ssh restart
    RETCODE=$?
fi

if [ "$RETCODE" -ne 0 ]
then
    echo 'ERROR: Fail to modify sshd_config. Please check!!'
else
    echo 'Finish modifing sshd_config.'
fi

exit $RETCODE
