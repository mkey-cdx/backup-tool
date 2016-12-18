#!/bin/bash

# ==============================================================================
# Rsync remote backup tool
#
# Maintainer: Mickaël Coiraton
# Version 0.0.1
# Updated: 18 December 2016
#
# This is a simple backup tool based on rsync and SSH.
# It creates a full backup from a remote machine to the local machine which 
# runs the script.
#
# IP or FQDN of remote machine
r_host=
# Remote username
r_user=
# Location of passphraseless ssh keyfile
r_key=
# Directories to backup. Separate with a space. Exclude trailing slash
sources=""
# Directory to backup to on the local machine. Exclude trailing slash.
target=""
# Comment out the following line to enable verbose output.
#verbose="-v"
# ==============================================================================

# SSH key verifications.
if [ ! -f $r_key ]; then
  echo "Couldn't find ssh keyfile!"
  echo "Exiting..."
  exit 2
fi

if ! ssh -i $r_key $r_user@$r_host "test -x $sources"; then
  echo "Target directory on remote machine doesn't exist or bad permissions."
  echo "Exiting..."
  exit 2
fi

#DAY=$(date +%A)
#
#if [ -e /location/to/backup/incr/$DAY ] ; then
#  rm -fr /location/to/backup/incr/$DAY
#fi
#
#rsync -a --delete --inplace --backup --backup-dir=/location/to/backup/incr/$DAY /folder/to/backup/ /location/to/backup/full/ &> /dev/null
