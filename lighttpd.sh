#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2017 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

NAME=lighttpd
FILE=lighttpd-1.4.45
USER=lighttpd
GROUP=lighttpd
MYDIR=`pwd`
SRCDIR=/usr/local/src

if [ ! -f $FILE.tar.gz ]; then
    wget http://download.lighttpd.net/lighttpd/releases-1.4.x/$FILE.tar.gz
fi

#cd $SRCDIR
#git clone https://github.com/maxmind/geoip-api-c
#cd $SRCDIR/geoip-api-c
#./bootstrap
#./configure --silent
#make install
#cd $MYDIR

tar -xf ./$FILE.tar.gz -C $SRCDIR
cd $SRCDIR/$FILE
./bootstrap
./configure --silent --libdir=/usr/local/lib/lighttpd --with-openssl --with-zlib #--with-geoip
make install
cd $MYDIR

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

echo '' > ./fstab.tmp
echo '# omobus mount points:' >> ./fstab.tmp
echo 'tmpfs         /var/www/run                        tmpfs  rw,noexec,nosuid,nodev,size=3145728    0    0' >> ./fstab.tmp
echo 'tmpfs         /var/www/htdocs                     tmpfs  rw,noexec,nosuid,nodev,size=5242880    0    0' >> ./fstab.tmp
echo '/dev/random   /var/lib/omobus-scgi.d/dev/random   none   bind                                   0    0' >> ./fstab.tmp
echo '/dev/urandom  /var/lib/omobus-scgi.d/dev/urandom  none   bind                                   0    0' >> ./fstab.tmp

cp /etc/fstab /etc/fstab-
cat /etc/fstab- ./fstab.tmp > /etc/fstab
rm ./fstab.tmp
mount -a

ln -sr /etc/ssl/omobus/omobus.net.pem /etc/ssl/omobus/lighttpd.pem

systemctl daemon-reload
systemctl enable lighttpd

ufw allow 80/tcp
ufw allow 443/tcp

#wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
#gzip -d GeoIP.dat.gz
#mv ./GeoIP.dat /var/www/GeoIP.dat
#chown $USER:$GROUP /var/www/GeoIP.dat && chmod 644 /var/www/GeoIP.dat
