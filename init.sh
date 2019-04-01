#!/bin/bash

GTPATH="/home/git/.gitolite"
# if [ ! -f $php_index ]; then
if [ ! -d "$GTPATH" ]; then
  gitolite setup -pk /david.pub
  sed -i '/LOCAL_CODE.*GL_ADMIN_BASE/s/^\s*#//g' /home/git/.gitolite.rc 
  sed -i '/repo-specific-hooks/s/^\s*#//g' /home/git/.gitolite.rc
fi

sudo /usr/sbin/sshd -D

# while [ 1 ]
# do
#     sleep 2
#     echo "do nothing..."
# done