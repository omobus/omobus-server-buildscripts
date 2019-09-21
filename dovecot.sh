#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2019 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

NAME=Dovecot
FILE=dovecot-2.3.7.2
USER=omobus
GROUP=omobus
MYDIR=`pwd`
SRCDIR=/usr/local/src

rm -vf /usr/local/lib/dovecot/auth/*
rm -vf /usr/local/lib/dovecot/dict/*
rm -vf /usr/local/lib/dovecot/doveadm/*
rm -vf /usr/local/lib/dovecot/stats/*
rm -vf /usr/local/lib/dovecot/*
rm -vf /usr/local/libexec/dovecot/*

#if [ ! -f $FILE.tar.gz ]; then
##    wget http://www.dovecot.org/releases/2.3/$FILE.tar.gz
#    wget https://github.com/dovecot/core/archive/$FILE.tar.gz
#fi
#
#tar -xf ./$FILE.tar.gz -C $SRCDIR
#cd $SRCDIR/$FILE

cd $SRCDIR
git clone https://github.com/dovecot/core
mv $SRCDIR/core $SRCDIR/$FILE
cd $SRCDIR/$FILE
touch ./doc/wiki/Authentication.txt
## apt-get install gettext
./autogen.sh
PANDOC=false ./configure --silent --with-ldap --with-bzlib --with-zlib --with-ssl=openssl \
    --without-pam --without-nss --without-shadow --without-bsdauth \
    --localstatedir=/var
make
make install
cd $MYDIR
rm -vf /usr/local/lib/dovecot/auth/*.la
rm -vf /usr/local/lib/dovecot/auth/*.a
rm -vf /usr/local/lib/dovecot/dict/*.la
rm -vf /usr/local/lib/dovecot/dict/*.a
rm -vf /usr/local/lib/dovecot/doveadm/*.la
rm -vf /usr/local/lib/dovecot/doveadm/*.a
rm -vf /usr/local/lib/dovecot/stats/*.la
rm -vf /usr/local/lib/dovecot/stats/*.a
rm -vf /usr/local/lib/dovecot/*.la
rm -vf /usr/local/lib/dovecot/*.a

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
