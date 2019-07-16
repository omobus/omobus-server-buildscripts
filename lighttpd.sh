#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2019 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

NAME=lighttpd
FILE=lighttpd-1.4.54
USER=lighttpd
GROUP=lighttpd
MYDIR=`pwd`
SRCDIR=/usr/local/src

if [ ! -f $FILE.tar.gz ]; then
    wget http://download.lighttpd.net/lighttpd/releases-1.4.x/$FILE.tar.gz
fi

tar -xf ./$FILE.tar.gz -C $SRCDIR
cd $SRCDIR/$FILE
./configure --silent --libdir=/usr/local/lib/lighttpd --with-openssl --with-ldap
make install-strip
cd $MYDIR

rm /usr/local/sbin/lighttpd-angel
rm /usr/local/lib/lighttpd/*.la

ldconfig

groupadd $GROUP
useradd -g $GROUP -d /var/www -s /dev/null $USER

cp -r ./lighttpd/ /etc/
cp ./systemd/lighttpd.service /etc/systemd/system
chown root:root /etc/systemd/system/lighttpd.service && chmod 644 /etc/systemd/system/lighttpd.service
chown root:root /etc/lighttpd && chmod 755 /etc/lighttpd
chown $USER:$GROUP /etc/lighttpd/*.conf && chmod 600 /etc/lighttpd/*.conf

mkdir -m 700 -v -p /var/www/run && chown -v $USER:$GROUP /var/www/run
mkdir -m 700 -v -p /var/www/htdocs && chown -v $USER:$GROUP /var/www/htdocs
mkdir -m 700 -v -p /var/www/uploads && chown -v $USER:$GROUP /var/www/uploads
mkdir -m 700 -v -p /var/www/log && chown -v $USER:$GROUP /var/www/log

mkdir -m 755 -p /var/www/dev && chown -fv root:root /var/www/dev
touch /var/www/dev/null

ln -sr /etc/ssl/omobus/omobus.net.pem /etc/ssl/omobus/lighttpd.pem

systemctl daemon-reload
systemctl enable lighttpd

ufw allow 80/tcp
ufw allow 443/tcp
