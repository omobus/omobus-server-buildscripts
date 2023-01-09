#!/bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2023 ak-obs, Ltd. <info@omobus.net>.

echo '' > ./fstab.tmp
echo '# omobus mount points:' >> ./fstab.tmp
echo 'tmpfs         /var/www/run                        tmpfs  rw,noexec,nosuid,nodev,size=3145728                         0    0' >> ./fstab.tmp
echo 'tmpfs         /var/www/htdocs                     tmpfs  rw,noexec,nosuid,nodev,size=150M                            0    0' >> ./fstab.tmp
echo '/dev/null     /var/www/dev/null                   none   bind                                                        0    0' >> ./fstab.tmp
echo '/dev/random   /var/lib/omobus-scgi.d/dev/random   none   bind                                                        0    0' >> ./fstab.tmp
echo '/dev/urandom  /var/lib/omobus-scgi.d/dev/urandom  none   bind                                                        0    0' >> ./fstab.tmp
echo '#tmpfs        /var/cache/omobus.d                 tmpfs  rw,noexec,nosuid,nodev,size=32G,uid=902,gid=905,mode=0700   0    0' >> ./fstab.tmp

cp /etc/fstab /etc/fstab-
cat /etc/fstab- ./fstab.tmp > /etc/fstab
rm ./fstab.tmp
mount -av
