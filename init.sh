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
  chown git:git /home/git
  su - git -c "gitolite setup -pk /david.pub"
  sed -i '/LOCAL_CODE.*GL_ADMIN_BASE/s/^\s*#//g' /home/git/.gitolite.rc 
  sed -i '/repo-specific-hooks/s/^\s*#//g' /home/git/.gitolite.rc
  # # change repo gitolite-admin to git-admin
  # mv /home/git/repositories/git{olite,}-admin.git
  # sed -i 's/gitolite-admin/git-admin/' /home/git/repositories/git-admin.git/gl-conf
  # sed -i 's/gitolite-admin/git-admin/' /home/git/.gitolite/conf/gitolite.conf
  # sed -i 's/gitolite-admin/git-admin/' /home/git/.gitolite/conf/gitolite.conf-compiled.pm
  # # todo: after clone git-admin, change git-admin/conf/gitolite.conf gitolite-admin to git-admin and push
  # su - git -c "git config --global user.email git@`hostname` && git config --global user.name `hostname`"
  # # can not commit and change gitolite-admin, because it's restricted by keypair
  # su - git -c "git clone /home/git/repositories/git-admin /tmp/ga && cd /tmp/ga && sed -i 's/gitolite-admin/git-admin/' conf/gitolite.conf && git commit -am 'change to git-admin' && git push"

fi

/usr/sbin/sshd -D

# while [ 1 ]
# do
#     sleep 2
#     echo "do nothing..."
# done