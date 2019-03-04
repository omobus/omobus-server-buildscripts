#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2019 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

MYDIR=`pwd`
SRCDIR=/usr/local/src

cd $SRCDIR
git clone https://github.com/jemalloc/jemalloc
cd $SRCDIR/jemalloc
./autogen.sh
./configure --silent --disable-cxx
make
make install_lib
make install_include
make install_bin
cd $MYDIR
