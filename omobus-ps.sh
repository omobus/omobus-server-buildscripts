#! /bin/sh
# This file is a part of the omobus project.
# Copyright (c) 2006 - 2023 ak-obs, Ltd. <support@omobus.net>.

ps -C omobusd,omobus-scgid,omobus-agentd,pure-ftpd,lighttpd,slapd,postgres,postmaster,exim,dovecot,dovecot-auth,pop3-login -F
