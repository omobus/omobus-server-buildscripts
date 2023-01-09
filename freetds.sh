#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2023 ak-obs, Ltd. <info@omobus.net>.

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
