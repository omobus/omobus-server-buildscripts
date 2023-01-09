#! /bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2023 ak-obs, Ltd. <support@omobus.net>.

d=$(date)

# checking dovecot pop3-login processes
count=$(/usr/local/bin/doveadm process status | /bin/grep -c pop3-login)

if [ "$count" -gt "15" ]; then
    msg="Dovecot [pop3-login] processes more then 15."
    /bin/echo "$d $msg" >> /var/log/omobus.d/stats.log
    /bin/echo "insert into mail_stream(rcpt_to, cap, msg) values (string_to_array(\"paramText\"('srv:push'),','), format('OMOBUS: Dovecot (%s)', \"paramUID\"('db:id')), '$msg')" | \
	/bin/su omobus -c "/usr/local/libexec/pgsql-14/bin/psql -d omobus-proxy-db -A"
    /bin/systemctl restart dovecot
fi;

# checking postgresql [omobus-proxy-db] processes
count=$(/usr/local/bin/omobus-ps | /bin/grep postgres | /bin/grep -c omobus-proxy-db)

if [ "$count" -gt "14" ]; then
    msg="PostgreSQL [omobus-proxy-db] processes more then 14."
    /bin/echo "$d $msg" >> /var/log/omobus.d/stats.log
    /bin/echo "insert into mail_stream(rcpt_to, cap, msg) values (string_to_array(\"paramText\"('srv:push'),','), format('OMOBUS: PostgreSQL (%s)', \"paramUID\"('db:id')), '$msg')" | \
	/bin/su omobus -c "/usr/local/libexec/pgsql-14/bin/psql -d omobus-proxy-db -A"
fi;

exit
