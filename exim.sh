#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2023 ak-obs, Ltd. <info@omobus.net>.

NAME=Exim
FILE=exim-4.97
#FILE=exim-4.96.2
USER=omobus
GROUP=omobus
MYDIR=`pwd`
SRCDIR=/usr/local/src

if [ ! -f $FILE.tar.bz2 ]; then
    wget http://exim.mirror.gtcomm.net/exim/exim4/$FILE.tar.bz2
fi

# exim-4.97:
apt-get install -y libfile-fcntllock-perl libgnutls28-dev

rm -vf /usr/local/sbin/exim
rm -vf /usr/local/sbin/exim-4.90*
rm -vf /usr/local/sbin/exim-4.92*
rm -vf /usr/local/sbin/exim-4.94*
rm -vf /usr/local/sbin/exim-4.95*
rm -vf /usr/local/sbin/exim-4.96*

tar -xf ./$FILE.tar.bz2 -C $SRCDIR
cd $SRCDIR/$FILE
cp $MYDIR/exim.rules $SRCDIR/$FILE/Local/Makefile
make install
cd $MYDIR

rm -vf /usr/local/sbin/exi*.O

cp -r ./exim/ /etc/
cp ./systemd/exim.service /etc/systemd/system
chown root:root /etc/systemd/system/exim.service && chmod 644 /etc/systemd/system/exim.service
chown root:root /etc/exim && chmod 644 /etc/exim
chown root:root /etc/exim/exim.conf && chmod 600 /etc/exim/exim.conf
touch /var/lib/omobus.d/whitelist && chown omobus:omobus /var/lib/omobus.d/whitelist && chmod 600 /var/lib/omobus.d/whitelist

mkdir -m 750 /var/log/exim && chown $USER:$GROUP /var/log/exim

ln -sr /etc/ssl/omobus/omobus.net.pem /etc/ssl/omobus/exim.pem

chown $USER:$GROUP /var/mail && chmod 750 /var/mail

systemctl daemon-reload
systemctl enable exim

ufw deny 25/tcp
