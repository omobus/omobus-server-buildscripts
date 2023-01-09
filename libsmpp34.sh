#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2023 ak-obs, Ltd. <info@omobus.net>.

FILE=libsmpp34-1.14.0
MYDIR=`pwd`
SRCDIR=/usr/local/src

tar -xf ./$FILE.tar.gz -C $SRCDIR
cd $SRCDIR/$FILE
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf
./configure --silent --includedir=/usr/local/include/libsmpp34
make install-strip
cd $MYDIR
