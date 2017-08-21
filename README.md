# OMOBUS server scripts

In this project defines the scripts that used to prepare the OMOBUS 
server based on the operating system with the Linux kernel.

1. Install the Debian 9.x:

recomended partition table is:
    * /       = 20 Gb
    * /var    > 200 Gb
    * swap    = 0 Gb (without swap)

required software during installation process is:

    * SSH server

2. Configure Debian:

    \# apt-get install sudo ufw git-core mc sudo

3. Create extra logins:

    # useradd -m -s /bin/bash XXX && passwd XXX

4. Edit sudo rules:

    # mcedit /etc/sudoers

5. Reconnect to the server with new user login (if needed).

6. Change SSH port (if needed) to the 22022:

    $ sudo mcedit /etc/ssh/sshd_config
    $ sudo ufw allow 22022/tcp
    $ sudo systemctl restart ssh

7. Enable firewall:

    $ sudo ufw enable

8. Disable root login:

    $ sudo passwd -l root

9. Change systemd tymesync service configuration:

    $ mcedit /etc/systemd/timesync.conf

and add: NTP=pool.ntp.org

10. Prepare OMOBUS environment:

    $ git clone https://github.com/omobus/omobus-server-buildscripts
    $ cd ./omobus-server-buildscripts
    $ sudo sh ./debian.sh

After all, install omobus services.


# LICENSE

Copyright (c) 2006 - 2017 ak-obs, Ltd. <info@omobus.net>.
All rights reserved.

This program is a free software. Redistribution and use in source
and binary forms, with or without modification, are permitted provided
that the following conditions are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

2. The origin of this software must not be misrepresented; you must
   not claim that you wrote the original software.

3. Altered source versions must be plainly marked as such, and must
   not be misrepresented as being the original software.

4. The name of the author may not be used to endorse or promote
   products derived from this software without specific prior written
   permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
