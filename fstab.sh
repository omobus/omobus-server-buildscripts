#!/bin/sh
# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2019 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

echo '' > ./fstab.tmp
echo '# omobus mount points:' >> ./fstab.tmp
echo 'tmpfs         /var/www/run                        tmpfs  rw,noexec,nosuid,nodev,size=3145728                         0    0' >> ./fstab.tmp
echo 'tmpfs         /var/www/htdocs                     tmpfs  rw,noexec,nosuid,nodev,size=5242880                         0    0' >> ./fstab.tmp
echo '/dev/random   /var/lib/omobus-scgi.d/dev/random   none   bind                                                        0    0' >> ./fstab.tmp
echo '/dev/urandom  /var/lib/omobus-scgi.d/dev/urandom  none   bind                                                        0    0' >> ./fstab.tmp
echo '#tmpfs        /var/cache/omobus.d/_ramfs          tmpfs  rw,noexec,nosuid,nodev,size=32G,uid=902,gid=905,mode=0700   0    0' >> ./fstab.tmp

cp /etc/fstab /etc/fstab-
cat /etc/fstab- ./fstab.tmp > /etc/fstab
rm ./fstab.tmp
mount -av