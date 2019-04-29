#!/bin/bash
log () {
    printf "[%(%Y-%m-%d %T)T] %s\n" -1 "$*"
}
log "SSMTP_HOST=${SSMTP_HOST:=smtp.exmail.qq.com:587}"
log "SSMTP_USER=${SSMTP_USER:=david}"
log "SSMTP_PASSWORD=${SSMTP_PASSWORD:=freego}"
HOSTNAME=$(hostname)
cat <<EOT > /etc/ssmtp/ssmtp.conf
UseTLS=YES
UseSTARTTLS=YES
root=${SSMTP_USER}
mailhub=${SSMTP_HOST}
AuthUser=${SSMTP_USER}
AuthPass=${SSMTP_PASSWORD}
hostname=${HOSTNAME}
FromLineOverride=YES
EOT

GTPATH="/home/git/.gitolite"
# if [ ! -f $php_index ]; then
if [ ! -d "$GTPATH" ]; then
  chown git:65534 /home/git
  su - git -c "gitolite setup -pk /david.pub"
  sed -i '/LOCAL_CODE.*GL_ADMIN_BASE/s/^\s*#//g' /home/git/.gitolite.rc 
  sed -i '/repo-specific-hooks/s/^\s*#//g' /home/git/.gitolite.rc
fi

/usr/sbin/sshd -D

# while [ 1 ]
# do
#     sleep 2
#     echo "do nothing..."
# done