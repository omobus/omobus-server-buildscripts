#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2020 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

VER=5.2.1
FILE=jemalloc-$VER
MYDIR=`pwd`
SRCDIR=/usr/local/src

if [ ! -f $FILE.tar.gz ]; then
    wget -O ./$FILE.tar.gz https://github.com/jemalloc/jemalloc/archive/$VER.tar.gz
fi

tar -xf ./$FILE.tar.gz -C $SRCDIR
cd $SRCDIR/$FILE
./autogen.sh
./configure --silent --disable-cxx
make
make install_lib
make install_include
make install_bin
cd $MYDIR
