#!/bin/bash

# ==============================================================================
# Rsync remote backup tool
#
# Maintainer: Mickaël Coiraton
# Version 0.0.1
# Updated: 18 December 2016
#
# This is a simple backup tool based on rsync and SSH.
# It backups selected directories from a remote machine to the local machine 
# which runs the script.
#
# IP or FQDN of remote machine
r_host=remote_host
# Remote username
r_user=remote_user
# Location of passphraseless ssh keyfile
ssh_key=/path/to/local/ssh_keyfile
# Directories to backup. Separate with a space. Exclude trailing slash
sources="/path/to/remote/directory"
# Directory to backup to on the local machine. Exclude trailing slash.
target="/path/to/local/backup"
# Comment out the following line to enable verbose output.
#verbose="-v"
# ==============================================================================

# SSH keyfile checking.
if [ ! -f $key ]; then
  echo "Couldn't find ssh keyfile!"
  echo "Exiting..."
  exit 2
fi

# Remote permissions checking.
if ! ssh -i $key $r_user@$r_host "test -x $sources"; then
  echo "Target directory on remote machine doesn't exist or bad permissions."
  echo "Exiting..."
  exit 2
fi

# Set name (date) of backup.
backup_date="`date +%F_%H-%M`"

#DAY=$(date +%A)
#
#if [ -e /location/to/backup/incr/$DAY ] ; then
#  rm -fr /location/to/backup/incr/$DAY
#fi
#
#rsync -a --delete --inplace --backup --backup-dir=/location/to/backup/incr/$DAY /folder/to/backup/ /location/to/backup/full/ &> /dev/null
