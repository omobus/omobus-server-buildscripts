#! /bin/sh

# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2017 ak-obs, Ltd. <info@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

DATE_MARK=`date +%Y%m%d%H%M`
#DATE_MARK=`date +%w`
PGDUMP=/usr/local/libexec/pgsql-9.6/bin/pg_dump
CURL=/usr/bin/curl
BZIP2=/bin/bzip2
SLAPCAT=/usr/local/sbin/slapcat
TAR=/bin/tar
SU=/bin/su
RM=/bin/rm
CHOWN=/bin/chown
MKDIR=/bin/mkdir

SLAPD_CONF=/etc/slapd/slapd.conf
BACKUP_PATH=/var/lib/omobus.d/backups
DATA_PATH=/var/lib/omobus.d/data
DB_FILE=omobus-proxy-db
LDAP_FILE=omobus-users
DATA_FILE=omobus-data

HOST=backups.omobus.net:21021
USER=none
PASSWD=none

if test -f /etc/default/omobus-backup; then
    . /etc/default/omobus-backup
fi

$MKDIR -p $BACKUP_PATH
$CHOWN omobus:omobus $BACKUP_PATH
$RM -f $BACKUP_PATH/$LDAP_FILE.ldif.bz2
$RM -f $BACKUP_PATH/$DB_FILE.pgd

$SLAPCAT -f $SLAPD_CONF -b "dc=omobus,dc=local" | $BZIP2 > $BACKUP_PATH/$LDAP_FILE.ldif.bz2
$TAR -cf $BACKUP_PATH/$DATA_FILE.tar $DATA_PATH
$SU omobus -c "$PGDUMP -Fc -f $BACKUP_PATH/$DB_FILE.pgd omobus-proxy-db"

# --verbose
$CURL --ftp-create-dirs --retry 40 --retry-delay 60 --ssl --cacert /etc/ssl/certs/OMOBUS_Root_Certification_Authority.pem --upload-file $BACKUP_PATH/$LDAP_FILE.ldif.bz2 --user $USER:$PASSWD ftp://$HOST/$LDAP_FILE-$DATE_MARK.ldif.bz2 2> $BACKUP_PATH/$LDAP_FILE.log
$CURL --ftp-create-dirs --retry 40 --retry-delay 60 --ssl --cacert /etc/ssl/certs/OMOBUS_Root_Certification_Authority.pem --upload-file $BACKUP_PATH/$DATA_FILE.tar --user $USER:$PASSWD ftp://$HOST/$DATA_FILE-$DATE_MARK.tar 2> $BACKUP_PATH/$DATA_FILE.log
$CURL --ftp-create-dirs --retry 40 --retry-delay 60 --ssl --cacert /etc/ssl/certs/OMOBUS_Root_Certification_Authority.pem --upload-file $BACKUP_PATH/$DB_FILE.pgd --user $USER:$PASSWD ftp://$HOST/$DB_FILE-$DATE_MARK.pgd 2> $BACKUP_PATH/$DB_FILE.log

exit 0

# The end of the script.
