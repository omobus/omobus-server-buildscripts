#! /bin/sh

# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2019 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

DATE_MARK=`date +%Y%m%d%H%M`
#DATE_MARK=`date +%w`
PGDUMP=/usr/local/libexec/pgsql-9.6/bin/pg_dump
BZIP2=/bin/bzip2
SLAPCAT=/usr/local/sbin/slapcat
TAR=/bin/tar
SU=/bin/su
RM=/bin/rm
MV=/bin/mv
CHOWN=/bin/chown
MKDIR=/bin/mkdir

SLAPD_CONF=/etc/slapd/slapd.conf
BACKUP_PATH=/var/lib/omobus.d/backups
DATA_PATH=/var/lib/omobus.d/data
DB_FILE=omobus-proxy-db
LDAP_FILE=omobus-users
DATA_FILE=omobus-data

$MKDIR -p $BACKUP_PATH
$CHOWN omobus:omobus $BACKUP_PATH
$RM -f $BACKUP_PATH/$LDAP_FILE.1.ldif.bz2
$MV $BACKUP_PATH/$LDAP_FILE.ldif.bz2 $BACKUP_PATH/$LDAP_FILE.1.ldif.bz2
$RM -f $BACKUP_PATH/$DB_FILE.1.pgd
$MV $BACKUP_PATH/$DB_FILE.pgd $BACKUP_PATH/$DB_FILE.1.pgd

$SLAPCAT -f $SLAPD_CONF -b "dc=omobus,dc=local" | $BZIP2 > $BACKUP_PATH/$LDAP_FILE.ldif.bz2
$TAR -cf $BACKUP_PATH/$DATA_FILE.tar $DATA_PATH
$SU omobus -c "$PGDUMP -Fc -f $BACKUP_PATH/$DB_FILE.pgd omobus-proxy-db"

exit 0

# The end of the script.
