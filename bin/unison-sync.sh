#!/bin/bash
# rferris December 2016
# vim: shiftwidth=4:tabstop=4:expandtab
# We're going to mount a cifs share and two-way sync it with
# a volume mounted dropbox folder. This will be done with unison


# Fun fact! Bash lets you instantiate a trap to listen for interrupts.
# By setting the sleep at the bottom of this file to be backgrounded
# and then using the wait command (to wait for the backgrounded sleep to finish)
# our trap still works and allows us to ctrl-c quit without having to wait for the sleep
# to finish.
trap '{ echo "Exiting." ; exit 1; }' INT

CIFSDIR=/mnt/cifsdir
DROPDIR=/mnt/dropbox

# Variables we're expecting. Quit if we don't get them.
for i in SHARENAME SHAREUSER SHAREPASS
do
    if [ -z "${!i}" ]
    then
        echo "$i" not set. Exiting.
        exit
    fi
done

# Check the dropbox volume exists
if [ ! -d "$DROPDIR" ]
then
    echo "Dropbox directory does not exist. Exiting."
    exit
fi

# Mount the cifs dir
mkdir $CIFSDIR
mount.cifs -o username=$SHAREUSER,password=$SHAREPASS $SHARENAME $CIFSDIR &


# Keep going foooreeeeveeerrrrr
while true
do
    # Don't do stuff unless we've got a cifs mount...
    ISMOUNTED=$(mount | grep -c $CIFSDIR)

    if [ $ISMOUNT -eq 0 ]
    then
        echo "$CIFSDIR not mounted. Exiting." 
        exit
    fi

    # It's allliiiivvee!
    unison -batch $CIFSDIR $DROPDIR
    # ZzZzZz
    sleep 60 &
    wait
done
