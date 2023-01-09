#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2023 ak-obs, Ltd. <info@omobus.net>.

MYDIR=`pwd`
VER=3.0.4
FILE=acme.sh-$VER
SRCDIR=/usr/local/src
DATADIR=/etc/ssl/omobus/.acme-data
LOGFILE=$DATADIR/letsencrypt.log
HTDIR=/var/www/htdocs
LIGHTTPDCERT=/etc/ssl/omobus/lighttpd.pem
COOKIE=`date +%Y%m%d%H%M`

## remove obsolete data:
rm -fv /var/log/letsencrypt.log

## issuance of a certificate:
if [ -z $1 ]; then
    echo 'Please, define domain name.'
    exit
fi

# https://github.com/acmesh-official/acme.sh
tar -xf ./$FILE.tar.gz -C $SRCDIR
cd $SRCDIR/$FILE

mkdir -m 0700 -pv $DATADIR
echo "ACCOUNT_EMAIL='support@omobus.net'" > $DATADIR/account.conf

$SRCDIR/$FILE/acme.sh --force --issue --home $DATADIR -d $1 -w $HTDIR --use-wget --syslog 3 --log $LOGFILE --log-level 2
cat $DATADIR/$1/fullchain.cer $DATADIR/$1/$1.key > $DATADIR/lighttpd-$COOKIE.pem
chmod 0600 $DATADIR/lighttpd-$COOKIE.pem
chown omobus:omobus $DATADIR/lighttpd-$COOKIE.pem
rm $LIGHTTPDCERT
ln -s $DATADIR/lighttpd-$COOKIE.pem $LIGHTTPDCERT

## renew script:
echo "#!/bin/sh" > $DATADIR/$1-renew.sh
echo "" >> $DATADIR/$1-renew.sh
echo "COOKIE=\`date +%Y%m%d%H%M\`" >> $DATADIR/$1-renew.sh
echo "" >> $DATADIR/$1-renew.sh
echo "$SRCDIR/$FILE/acme.sh --force --renew --home $DATADIR -d $1 -w $HTDIR --use-wget --syslog 3 --log $LOGFILE --log-level 2" >> $DATADIR/$1-renew.sh
echo "cat $DATADIR/$1/fullchain.cer $DATADIR/$1/$1.key > $DATADIR/lighttpd-\$COOKIE.pem" >> $DATADIR/$1-renew.sh
echo "chmod 0600 $DATADIR/lighttpd-\$COOKIE.pem" >> $DATADIR/$1-renew.sh
echo "chown omobus:omobus $DATADIR/lighttpd-\$COOKIE.pem" >> $DATADIR/$1-renew.sh
echo "rm $LIGHTTPDCERT" >> $DATADIR/$1-renew.sh
echo "ln -s $DATADIR/lighttpd-\$COOKIE.pem $LIGHTTPDCERT" >> $DATADIR/$1-renew.sh

## crontab:
echo "33 0 10,20,30 * * root /bin/sh $DATADIR/$1-renew.sh && /bin/systemctl restart lighttpd" > /etc/cron.d/letsencrypt
chown root:root /etc/cron.d/letsencrypt
chmod 644 /etc/cron.d/letsencrypt
