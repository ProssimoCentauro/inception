#!/bin/bash

if ! id "${FTP_USER}" &>/dev/null; then
    useradd -m -s /bin/bash "${FTP_USER}"
    echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
    echo "${FTP_USER}" >> /etc/vsftpd.userlist
fi

mkdir -p /var/run/vsftpd
chown root:root /var/run/vsftpd
chmod 755 /var/run/vsftpd

exec vsftpd /etc/vsftpd.conf
