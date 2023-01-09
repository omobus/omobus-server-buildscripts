#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2023 ak-obs, Ltd. <info@omobus.net>.

NAME=PostgreSQL
VER=14.6
FILE=postgresql-$VER
PREFIX=/usr/local/libexec/pgsql-14
MYDIR=`pwd`
SRCDIR=/usr/local/src
DBDIR=/var/lib/pgsql/data

if [ ! -f $FILE.tar.bz2 ]; then
    wget http://ftp.postgresql.org/pub/source/v$VER/$FILE.tar.bz2
fi

tar -xf ./$FILE.tar.bz2 -C $SRCDIR
cd $SRCDIR/$FILE
./configure --silent --disable-thread-safety --with-uuid=e2fs --with-systemd --prefix=$PREFIX #--with-ldap --with-openssl --with-libxml
make install
cd ./contrib/hstore/
make install
cd ../isn/
make install
cd ../uuid-ossp/
make install
cd $MYDIR

ln -sfv $PREFIX/bin/psql /usr/local/bin/psql
ln -sfv $PREFIX/include /usr/local/include/pgsql
ln -sfv $PREFIX/lib/libpq.so.5.14 /usr/local/lib/libpq.so.5.14
ln -sfv libpq.so.5.14 /usr/local/lib/libpq.so.5
ln -sfv libpq.so.5 /usr/local/lib/libpq.so

ldconfig

groupadd postgres
useradd -g postgres -d /var/lib/pgsql -s /bin/bash postgres

cp ./systemd/pgsql.service /etc/systemd/system
chown root:root /etc/systemd/system/pgsql.service && chmod 644 /etc/systemd/system/pgsql.service

mkdir -m 700 /var/lib/pgsql && chown postgres:postgres /var/lib/pgsql
mkdir -m 700 $DBDIR && chown postgres:postgres $DBDIR

su postgres -c "$PREFIX/bin/initdb -D $DBDIR"

mv $DBDIR/pg_hba.conf $DBDIR/pg_hba.conf-
echo "# TYPE  DATABASE        USER            ADDRESS                 METHOD" > $DBDIR/pg_hba.conf
echo "# \"local\" is for Unix domain socket connections only" >> $DBDIR/pg_hba.conf
echo "local   all             all                                     trust" >> $DBDIR/pg_hba.conf
echo "# omobus-proxy-db connections:" >> $DBDIR/pg_hba.conf
echo "host    all         omobus      127.0.0.1/32          md5" >> $DBDIR/pg_hba.conf
chmod 0600 $DBDIR/pg_hba.conf && chown postgres:postgres $DBDIR/pg_hba.conf

mv $DBDIR/postgresql.conf $DBDIR/postgresql.conf-
echo "# $NAME $VER configuration:" >> $DBDIR/postgresql.conf
echo "" >> $DBDIR/postgresql.conf
echo "max_connections = 20" >> $DBDIR/postgresql.conf
echo "" >> $DBDIR/postgresql.conf
echo "wal_level = minimal" >> $DBDIR/postgresql.conf
echo "max_wal_senders = 0" >> $DBDIR/postgresql.conf
echo "max_replication_slots = 0" >> $DBDIR/postgresql.conf
echo "max_wal_size = 4GB" >> $DBDIR/postgresql.conf
echo "min_wal_size = 80MB" >> $DBDIR/postgresql.conf
echo "" >> $DBDIR/postgresql.conf
echo "log_destination = 'csvlog'" >> $DBDIR/postgresql.conf
echo "logging_collector = on" >> $DBDIR/postgresql.conf
echo "log_directory = 'log'" >> $DBDIR/postgresql.conf
echo "log_rotation_age = 30d" >> $DBDIR/postgresql.conf
echo "log_rotation_size = 10MB" >> $DBDIR/postgresql.conf
echo "log_timezone = 'Europe/Moscow'" >> $DBDIR/postgresql.conf
echo "" >> $DBDIR/postgresql.conf
echo "#shared_buffers = 2GB" >> $DBDIR/postgresql.conf
echo "#temp_buffers = 512MB" >> $DBDIR/postgresql.conf
echo "#effective_cache_size = 6GB" >> $DBDIR/postgresql.conf
echo "#work_mem = 32MB # large value may leads to performance degradation!!!" >> $DBDIR/postgresql.conf
echo "#maintenance_work_mem = 2GB" >> $DBDIR/postgresql.conf
echo "#max_locks_per_transaction = 128" >> $DBDIR/postgresql.conf
echo "" >> $DBDIR/postgresql.conf
echo "timezone = 'Europe/Moscow'" >> $DBDIR/postgresql.conf
chmod 0600 $DBDIR/postgresql.conf && chown postgres:postgres $DBDIR/postgresql.conf

systemctl daemon-reload
systemctl enable pgsql

systemctl start pgsql
su postgres -c "echo \"CREATE USER omobus PASSWORD 'omobus'; ALTER USER omobus SUPERUSER;\" | psql"

