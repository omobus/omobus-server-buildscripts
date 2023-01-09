#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2022 ak-obs, Ltd. <info@omobus.net>.

NAME=Pure-FTPd
FILE=pure-ftpd-1.0.51
MYDIR=`pwd`
SRCDIR=/usr/local/src

if [ ! -f $FILE.tar.gz ]; then
    wget --no-check-certificate https://download.pureftpd.org/pub/pure-ftpd/releases/$FILE.tar.gz
fi

tar -xf ./$FILE.tar.gz -C $SRCDIR
cd $SRCDIR/$FILE
./configure --silent --with-ldap --with-language=english --with-peruserlimits --with-diraliases \
    --with-ftpwho --with-altlog --with-virtualchroot --without-inetd --without-shadow --with-tls \
    --with-certfile=/etc/ssl/omobus/pure-ftpd.pem
make install
cd $MYDIR

cp -r ./pure-ftpd/ /etc/
cp ./systemd/pure-ftpd.service /etc/systemd/system
chown root:root /etc/systemd/system/pure-ftpd.service && chmod 644 /etc/systemd/system/pure-ftpd.service
chown root:root /etc/pure-ftpd && chmod 644 /etc/pure-ftpd
chown root:root /etc/pure-ftpd/pure-ftpd.conf && chmod 600 /etc/pure-ftpd/pure-ftpd.conf
chown root:root /etc/pure-ftpd/pure-ftpd-ldap.conf && chmod 600 /etc/pure-ftpd/pure-ftpd-ldap.conf
rm -fv /etc/pure-ftpd.conf

ln -sr /etc/ssl/omobus/omobus.net.pem /etc/ssl/omobus/pure-ftpd.pem
openssl dhparam -out /etc/ssl/private/pure-ftpd-dhparams.pem 2048

mkdir -m 700 /var/ftp && chown omobus:omobus /var/ftp

systemctl daemon-reload
systemctl enable pure-ftpd

ufw allow 21021/tcp
ufw allow 49152:65534/tcp
