#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2022 ak-obs, Ltd. <info@omobus.net>.

apt-get update
apt-get upgrade -y
apt-get install mc ufw man git-core groff-base gcc make automake autoconf libtool shtool pkg-config gettext bison flex gawk wput wget curl uuid-dev libxml2-dev libz-dev libbz2-dev libpcre3-dev libreadline-dev libssl-dev libdb-dev libjpeg-dev libsystemd-dev -y

timedatectl set-ntp true

groupadd omobus -g 905
useradd -g omobus -d /var/lib/omobus -s /bin/bash -m -u 902 omobus

mkdir -m 700 -v -p /etc/ssl/omobus && chown -v omobus:omobus /etc/ssl/omobus
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
mkdir -m 700 -p /var/log/omobus-scgi.d && chown -fv syslog:omobus /var/log/omobus-scgi.d
mkdir -m 700 -p /var/log/omobus-scgi.d-OLD && chown -fv omobus:omobus /var/log/omobus-scgi.d-OLD
mkdir -m 700 -p /var/cache/omobus.d && chown -fv omobus:omobus /var/cache/omobus.d
mkdir -m 700 -p /var/spool/omobus.d && chown -fv omobus:omobus /var/spool/omobus.d
mkdir -m 700 -p /var/lib/omobus.d && chown -fv omobus:omobus /var/lib/omobus.d
mkdir -m 700 -p /var/lib/omobus-scgi.d && chown -fv omobus:omobus /var/lib/omobus-scgi.d
mkdir -m 755 -p /var/lib/omobus-scgi.d/dev && chown -fv root:root /var/lib/omobus-scgi.d/dev

cp ./OMOBUS_Root_Certification_Authority.pem /var/lib/omobus.d
cp ./OMOBUS_Root_Certification_Authority.pem /var/lib/omobus-scgi.d
chmod 644 /var/lib/omobus.d/OMOBUS_Root_Certification_Authority.pem && chown root:root /var/lib/omobus.d/OMOBUS_Root_Certification_Authority.pem
chmod 644 /var/lib/omobus-scgi.d/OMOBUS_Root_Certification_Authority.pem && chown root:root /var/lib/omobus-scgi.d/OMOBUS_Root_Certification_Authority.pem

touch /var/lib/omobus-scgi.d/dev/random
touch /var/lib/omobus-scgi.d/dev/urandom

cp ./omobus-backup.sh /usr/local/bin/omobus-backup
cp ./omobus-backup.default /etc/default/omobus-backup
chmod 0755 /usr/local/bin/omobus-backup
chmod 0600 /etc/default/omobus-backup
chown root:root /usr/local/bin/omobus-backup /etc/default/omobus-backup

cp ./omobus-ps.sh /usr/local/bin/omobus-ps
chmod 0755 /usr/local/bin/omobus-ps
chown root:root /usr/local/bin/omobus-ps

#cp ./omobus-stats.sh /usr/local/bin/omobus-stats
#chmod 0755 /usr/local/bin/omobus-stats
#chown root:root /usr/local/bin/omobus-stats

sh ./fstab.sh

userdel -rf games
userdel -rf irc
userdel -rf www-data
