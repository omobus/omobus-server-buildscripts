#! /bin/sh

# This file is a part of the omobus-server-buildscripts project.
# Copyright (c) 2006 - 2019 ak-obs, Ltd. <support@omobus.net>.
# Author: Igor Artemov <i_artemov@ak-obs.ru>.

ps -C omobusd,omobus-scgid,omobus-agentd,pure-ftpd,lighttpd,slapd,postgres,postmaster,exim,dovecot,dovecot-auth,pop3-login -F
