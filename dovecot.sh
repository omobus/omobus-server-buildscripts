#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2022 ak-obs, Ltd. <info@omobus.net>.

NAME=Dovecot
VER=2.3.18
FILE=dovecot-$VER
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

if [ ! -f $FILE.tar.gz ]; then
    wget -O ./$FILE.tar.gz https://github.com/dovecot/core/archive/$VER.tar.gz
fi

tar -xf ./$FILE.tar.gz -C $SRCDIR
mv $SRCDIR/core-$VER $SRCDIR/$FILE
cd $SRCDIR/$FILE

# Controlling inactivity timeout:
# https://dovecot.org/pipermail/dovecot/2015-February/099713.html
# >>   /src/lib-master/master-interface.h
# >>   -#define MASTER_LOGIN_TIMEOUT_SECS (3*60)
# >>   +#define MASTER_LOGIN_TIMEOUT_SECS (110)

touch ./doc/wiki/Authentication.txt
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

ldconfig

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

ufw allow 25110/tcp
