#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2022 ak-obs, Ltd. <info@omobus.net>.

MYDIR=`pwd`
SRCDIR=/usr/local/src

if [ -z $1 ]; then
    echo 'Please, define domain name.'
    exit
fi

cd $SRCDIR
git clone https://github.com/Neilpang/acme.sh.git
cd $SRCDIR/acme.sh
mkdir -pv $SRCDIR/acme.sh/.data
echo "ACCOUNT_EMAIL='support@omobus.net'" > $SRCDIR/acme.sh/.data/account.conf 
$SRCDIR/acme.sh/acme.sh --force --issue --home $SRCDIR/acme.sh/.data -d $1 -w /var/www/htdocs --use-wget --syslog 3 --log /var/log/letsencrypt.log --log-level 2
rm /etc/ssl/omobus/lighttpd.pem
cat $SRCDIR/acme.sh/.data/$1/$1.cer $SRCDIR/acme.sh/.data/$1/$1.key > /etc/ssl/omobus/lighttpd.pem
chmod 600 /etc/ssl/omobus/lighttpd.pem
chown omobus:omobus /etc/ssl/omobus/lighttpd.pem
cd $MYDIR

echo "33 0 10,20,30 * * root $SRCDIR/acme.sh/acme.sh --force --renew --home $SRCDIR/acme.sh/.data -d $1 -w /var/www/htdocs --use-wget --syslog 3 --log /var/log/letsencrypt.log --log-level 2 && /bin/cat $SRCDIR/acme.sh/.data/$1/$1.cer $SRCDIR/acme.sh/.data/$1/$1.key > /etc/ssl/omobus/lighttpd.pem && /bin/chmod 600 /etc/ssl/omobus/lighttpd.pem && /bin/chown omobus:omobus /etc/ssl/omobus/lighttpd.pem && /bin/systemctl restart lighttpd" > /etc/cron.d/letsencrypt
chown root:root /etc/cron.d/letsencrypt
chmod 644 /etc/cron.d/letsencrypt
