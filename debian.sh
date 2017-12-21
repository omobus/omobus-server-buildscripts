#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2017 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

apt-get update
apt-get upgrade
apt-get install mc ufw man git-core groff-base gcc g++ gdb make automake autoconf libtool pkg-config bison flex gawk wput wget curl uuid-dev libxml2-dev libz-dev libbz2-dev libpcre3-dev libreadline-dev libssl-dev libdb-dev libjpeg-dev 

groupadd omobus -g 905
useradd -g omobus -d /var/lib/omobus -s /bin/bash -m -u 902 omobus

mkdir -m 700 -v -p /etc/ssl/omobus && chown -v omobus:omobus /etc/ssl/omobus
cp ./OMOBUS_Root_Certification_Authority.pem /etc/ssl/certs
chmod 600 /etc/ssl/certs/OMOBUS_Root_Certification_Authority.pem && chown omobus:omobus /etc/ssl/certs/OMOBUS_Root_Certification_Authority.pem
cp ./omobus.net.pem /etc/ssl/omobus
chmod 600 /etc/ssl/omobus/omobus.net.pem && chown omobus:omobus /etc/ssl/omobus/omobus.net.pem

mkdir -m 755 -v -p /usr/local/src && chown root:root /usr/local/src

sh ./slapd.sh
sh ./pure-ftpd.sh
sh ./exim.sh
sh ./dovecot.sh
sh ./pgsql.sh
sh ./lighttpd.sh
sh ./libexif.sh

cp ./cron.d/omobusd /etc/cron.d/omobusd
cp ./rsyslog.d/40-omobus-scgid.conf /etc/rsyslog.d/40-omobus-scgid.conf
cp ./logrotate.d/exim /etc/logrotate.d/exim
cp ./logrotate.d/dovecot /etc/logrotate.d/dovecot
cp ./logrotate.d/pgsql /etc/logrotate.d/pgsql
cp ./logrotate.d/pure-ftpd /etc/logrotate.d/pure-ftpd
cp ./logrotate.d/omobusd /etc/logrotate.d/omobusd
cp ./logrotate.d/omobus-scgid /etc/logrotate.d/omobus-scgid
chown root:root /etc/cron.d/omobusd /etc/logrotate.d/dovecot /etc/logrotate.d/exim /etc/logrotate.d/omobusd /etc/logrotate.d/omobus-scgid /etc/logrotate.d/pgsql  /etc/logrotate.d/pure-ftpd /etc/rsyslog.d/40-omobus-scgid.conf
chmod 644 /etc/cron.d/omobusd /etc/logrotate.d/dovecot /etc/logrotate.d/exim /etc/logrotate.d/omobusd /etc/logrotate.d/omobus-scgid /etc/logrotate.d/pgsql  /etc/logrotate.d/pure-ftpd /etc/rsyslog.d/40-omobus-scgid.conf

rm -rfv /usr/local/etc
rm -rfv /usr/local/games
rm -rfv /usr/local/var

mkdir -m 700 -p /etc/omobus.d && chown -fv omobus:omobus /etc/omobus.d
mkdir -m 700 -p /etc/omobus-scgi.d && chown -fv omobus:omobus /etc/omobus-scgi.d
mkdir -m 700 -p /var/log/omobus.d && chown -fv omobus:omobus /var/log/omobus.d
mkdir -m 700 -p /var/log/omobus.d-OLD && chown -fv omobus:omobus /var/log/omobus.d-OLD
mkdir -m 700 -p /var/log/omobus-scgi.d && chown -fv omobus:omobus /var/log/omobus-scgi.d
mkdir -m 700 -p /var/log/omobus-scgi.d-OLD && chown -fv omobus:omobus /var/log/omobus-scgi.d-OLD
mkdir -m 700 -p /var/cache/omobus.d && chown -fv omobus:omobus /var/cache/omobus.d
mkdir -m 700 -p /var/lib/omobus.d && chown -fv omobus:omobus /var/lib/omobus.d
mkdir -m 700 -p /var/lib/omobus-scgi.d && chown -fv omobus:omobus /var/lib/omobus-scgi.d
mkdir -m 755 -p /var/lib/omobus-scgi.d/dev && chown -fv root:root /var/lib/omobus-scgi.d/dev

touch /var/lib/omobus-scgi.d/dev/random
touch /var/lib/omobus-scgi.d/dev/urandom
cp /etc/ssl/certs/OMOBUS_Root_Certification_Authority.pem /var/lib/omobus-scgi.d/OMOBUS_Root_Certification_Authority.pem

cp ./omobus-backups.sh /usr/local/bin/omobus-backups
cp ./omobus-backups.default /etc/default/omobus-backups
chmod 0755 /usr/local/bin/omobus-backups
chmod 0600 /etc/default/omobus-backups
chown roor:root /usr/local/bin/omobus-backups /etc/default/omobus-backups

cp ./omobus-ps.sh /usr/local/bin/omobus-ps
chmod 0755 /usr/local/bin/omobus-ps
chown root:root /usr/local/bin/omobus-ps
