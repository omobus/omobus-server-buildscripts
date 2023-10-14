#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2023 ak-obs, Ltd. <info@omobus.net>.

FILE=libexif-0.6.24
MYDIR=`pwd`
SRCDIR=/usr/local/src

apt-get install autopoint -y

## https://github.com/libexif/libexif.git

tar -xf ./$FILE.tar.gz -C $SRCDIR
cd $SRCDIR/$FILE
autoreconf -i
./configure --silent
make install-strip
cd $MYDIR
