#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2021 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

NAME=PostgreSQL
VER=9.6.22
FILE=postgresql-$VER
PREFIX=/usr/local/libexec/pgsql-9.6
MYDIR=`pwd`
SRCDIR=/usr/local/src

if [ ! -f $FILE.tar.bz2 ]; then
    wget http://ftp.postgresql.org/pub/source/v$VER/$FILE.tar.bz2
fi

tar -xf ./$FILE.tar.bz2 -C $SRCDIR
cd $SRCDIR/$FILE
./configure --silent --disable-thread-safety --with-uuid=e2fs --with-systemd --prefix=$PREFIX #--with-ldap --with-openssl
make install
cd ./contrib/postgres_fdw/
make install
cd ../dblink/
make install
cd ../file_fdw/
make install
cd ../hstore/
make install
cd ../isn/
make install
cd ../uuid-ossp/
make install
cd $MYDIR

ln -s $PREFIX/bin/psql /usr/local/bin/psql
ln -s $PREFIX/bin/postgres /usr/local/sbin/postgres
ln -s $PREFIX/bin/pg_ctl /usr/local/sbin/pg_ctl
ln -s $PREFIX/include /usr/local/include/pgsql
ln -s $PREFIX/lib/libpq.so /usr/local/lib/libpq.so
ln -s $PREFIX/lib/libpq.so.5 /usr/local/lib/libpq.so.5
ln -s $PREFIX/lib/libpq.so.5.9 /usr/local/lib/libpq.so.5.9
ln -s $PREFIX/lib/libpq.a /usr/local/lib/libpq.a

ldconfig

groupadd postgres
useradd -g postgres -d /var/lib/pgsql -s /bin/bash postgres

cp ./systemd/pgsql.service /etc/systemd/system
chown root:root /etc/systemd/system/pgsql.service && chmod 644 /etc/systemd/system/pgsql.service

mkdir -m 700 /var/lib/pgsql && chown postgres:postgres /var/lib/pgsql
mkdir -m 700 /var/lib/pgsql/data && chown postgres:postgres /var/lib/pgsql/data

su postgres -c "$PREFIX/bin/initdb -D /var/lib/pgsql/data"

mv /var/lib/pgsql/data/pg_hba.conf /var/lib/pgsql/data/pg_hba.tmp

echo "# TYPE  DATABASE        USER            ADDRESS                 METHOD" > /var/lib/pgsql/data/pg_hba.conf
echo "# \"local\" is for Unix domain socket connections only" >> /var/lib/pgsql/data/pg_hba.conf
echo "local   all             all                                     trust" >> /var/lib/pgsql/data/pg_hba.conf
echo "# omobus-proxy-db connections:" >> /var/lib/pgsql/data/pg_hba.conf
echo "host    all         omobus      127.0.0.1/32          md5" >> /var/lib/pgsql/data/pg_hba.conf

chmod 0600 /var/lib/pgsql/data/pg_hba.conf && chown postgres:postgres /var/lib/pgsql/data/pg_hba.conf

systemctl daemon-reload
systemctl enable pgsql

systemctl start pgsql
su postgres -c "echo \"CREATE USER omobus PASSWORD 'omobus'; ALTER USER omobus SUPERUSER;\" | psql"

