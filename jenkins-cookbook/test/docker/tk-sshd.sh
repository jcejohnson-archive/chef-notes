#!/bin/sh
set -e
exec /usr/sbin/sshd -D -o UseDNS=no -o UsePAM=no -o PasswordAuthentication=yes -o UsePrivilegeSeparation=no -o PidFile=/tmp/sshd.pid
