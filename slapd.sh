#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2022 ak-obs, Ltd. <info@omobus.net>.

NAME=OpenLDAP
FILE=openldap-2.6.3
USER=openldap
GROUP=openldap
MYDIR=`pwd`
SRCDIR=/usr/local/src

if [ ! -f $FILE.tgz ]; then
    wget ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/$FILE.tgz
fi

tar -xf ./$FILE.tgz -C $SRCDIR
cd $SRCDIR/$FILE
./configure --silent --with-tls=openssl --enable-backends=no --enable-mdb=yes --enable-monitor=yes
make install
cd $MYDIR

ln -s /usr/local/libexec/slapd /usr/local/sbin/slapd

groupadd $GROUP
useradd -g $GROUP -d /var/lib/slapd -s /dev/null $USER

cp -r ./slapd/ /etc/
cp ./systemd/slapd.service /etc/systemd/system
chown root:root /etc/slapd && chmod 755 /etc/slapd
chown $USER:$GROUP /etc/slapd/slapd.conf && chmod 600 /etc/slapd/slapd.conf
chown $USER:$GROUP /etc/slapd/schema && chmod 755 /etc/slapd/schema
chown $USER:$GROUP /etc/slapd/schema/* && chmod 644 /etc/slapd/schema/*
chown root:root /etc/systemd/system/slapd.service && chmod 644 /etc/systemd/system/slapd.service

ln -sr /etc/ssl/omobus/omobus.net.pem /etc/ssl/omobus/slapd.pem

mkdir -m 700 -v -p /var/lib/slapd && chown -v $USER:$GROUP /var/lib/slapd

systemctl daemon-reload
systemctl enable slapd

echo " "
echo "*** -----------------------------------------------------------------------------"
echo "*** Current $NAME root password is \033[33m0\033[0m."
echo "*** Don't forget to change $NAME root pasword at the /etc/slapd/slapd.conf."
echo " "
