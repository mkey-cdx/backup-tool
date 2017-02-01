#!/bin/bash

# ==============================================================================
# Rsync remote backup tool
#
# Maintainer: Mickaël Coiraton
# Version 0.1.0
# Updated: 1 Febuary 2016
#
# This is a simple rotating backup tool based on rsync and SSH.
# It backups selected directories from a remote host to the local machine 
# which runs the script.
#
# Please edit the provided backup-tool.cfg file to match your needs.
# Note that you must set up a passphraseless SSH key pair and add the public
# key to your remote host authorized_keys file.
#
# ==============================================================================

# Source config file
source backup.cfg

# Get incremental dates
current_date=`date -I`
last_date=`date -I -d "1 "$interval" ago"`

# SSH keyfile checking
if [ ! -f $ssh_key ]; then
  echo "Couldn't find ssh keyfile!"
  echo "Exiting..."
  exit 2
fi

# Rsync exclude parameter
for dir in $exclude_dirs; do
    exclude="$exclude --exclude='$dir'"
done

# Running verification and rsync for each source
for source in $sources; do
    
    # Extract source folder name
    source_dir=${source##*/}

    # Check remote permissions
    if ! ssh -i $ssh_key $r_user@$r_host "test -x $source"; then
        echo "Error with $source!"
        echo "Target directory on remote machine doesn't exist or"\
             "bad permissions."
        echo "Exiting..."
        exit 2
    fi

    # Create local backup directory
    if [ ! -d $backup_dir/$current_date/$source_dir ]; then
        mkdir -p $backup_dir/$current_date/$source_dir
    fi
    
    # Run rsync
    rsync $exclude -av --delete -e "ssh -i $ssh_key" \
          $r_user@$r_host:$source/ \
          $backup_dir/$current_date/$source_dir

done

