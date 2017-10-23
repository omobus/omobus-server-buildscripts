#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2017 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

MYDIR=`pwd`
SRCDIR=/usr/local/src

if [ -z $1 ]; then
    echo 'Please, define domain name.'
    exit
fi

cd $SRCDIR
#git clone https://github.com/Neilpang/acme.sh.git
cd $SRCDIR/acme.sh
mkdir -pv $SRCDIR/acme.sh/.data
echo "ACCOUNT_EMAIL='support@omobus.net'" > $SRCDIR/acme.sh/.data/account.conf 
$SRCDIR/acme.sh/acme.sh --issue --home $SRCDIR/acme.sh/.data -d $1 -w /var/www/htdocs --use-wget --syslog 3 --log /var/log/letsencrypt.log --log-level 2
cd $MYDIR
