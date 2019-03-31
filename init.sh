#!/bin/bash

GTPATH="/home/git/.gitolite"
# if [ ! -f $php_index ]; then
if [ ! -d "$GTPATH" ]; then
  su - git -c "gitolite setup -pk /david.pub"
fi

/usr/sbin/sshd -D

# while [ 1 ]
# do
#     sleep 2
#     echo "do nothing..."
# done