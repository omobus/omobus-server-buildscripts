#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2019 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

FILE=freetds-0.91
MYDIR=`pwd`
SRCDIR=/usr/local/src

if [ ! -f $FILE.tar.gz ]; then
    wget http://omobus.net/$FILE.tar.gz
fi

tar -xf ./$FILE.tar.gz -C $SRCDIR
cd $SRCDIR/$FILE
###./configure --silent --disable-server --disable-pool --disable-odbc --with-tdsver=7.0 --with-gnutls --disable-debug
./configure --silent --disable-server --disable-pool --disable-odbc --with-tdsver=7.0 --disable-debug
make install
cd $MYDIR
