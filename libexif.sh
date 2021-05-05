#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2021 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

FILE=libexif-0.6.21
MYDIR=`pwd`
SRCDIR=/usr/local/src

tar -xf ./$FILE.tar.bz2 -C $SRCDIR
cd $SRCDIR/$FILE
./configure --silent
make install-strip
cd $MYDIR
