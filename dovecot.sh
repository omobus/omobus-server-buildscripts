#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2017 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

NAME=Dovecot
FILE=dovecot-2.2.31
USER=omobus
GROUP=omobus
MYDIR=`pwd`
SRCDIR=/usr/local/src

if [ ! -f $FILE.tar.gz ]; then
    wget http://www.dovecot.org/releases/2.2/$FILE.tar.gz
fi

tar -xf ./$FILE.tar.gz -C $SRCDIR
cd $SRCDIR/$FILE
./configure --silent --with-ldap --with-bzlib --with-zlib --with-ssl=openssl \
    --without-pam --without-nss --without-shadow --without-bsdauth \
    --localstatedir=/var
make
make install
cd $MYDIR

groupadd dovenull
useradd -g dovenull -d /dev/null -s /dev/null dovenull
groupadd dovecot
useradd -g dovecot -d /dev/null -s /dev/null dovecot

cp -r ./dovecot/ /etc/
cp ./systemd/dovecot.service /etc/systemd/system
chown root:root /etc/systemd/system/dovecot.service && chmod 644 /etc/systemd/system/dovecot.service
chown root:root /etc/dovecot && chmod 644 /etc/dovecot
chown root:root /etc/dovecot/dovecot.conf && chmod 600 /etc/dovecot/dovecot.conf
chown root:root /etc/dovecot/dovecot-ldap.conf && chmod 600 /etc/dovecot/dovecot-ldap.conf

ln -sr /etc/ssl/omobus/omobus.net.pem /etc/ssl/omobus/dovecot.pem

mkdir -m 750 -p /var/spool/dovecot && chown $USER:$GROUP /var/spool/dovecot

systemctl daemon-reload
systemctl enable dovecot

ufw allow 110/tcp
