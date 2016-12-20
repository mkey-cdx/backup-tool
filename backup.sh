#!/bin/bash

# ==============================================================================
# Rsync remote backup tool
#
# Maintainer: Mickaël Coiraton
# Version 0.0.1
# Updated: 18 December 2016
#
# This is a simple rotating backups tool based on rsync and SSH.
# It backups selected directories from a remote machine to the local machine 
# which runs the script.
#
# ==============================================================================

# Get backup config.
source backup.cfg

# SSH keyfile checking.
if [ ! -f $ssh_key ]; then
  echo "Couldn't find ssh keyfile!"
  echo "Exiting..."
  exit 2
fi

# Rsync exclude parameter.
for dir in $exclude_dirs; do
    exclude="$exclude --exclude=$dir"
done

# Running verification and rsync for each source.
for source in $sources; do

    # Check remote permissions.
    if ! ssh -i $ssh_key $r_user@$r_host "test -x $source"; then
        echo "Error with $source!"
        echo "Target directory on remote machine doesn't exist or bad permissions."
        echo "Exiting..."
        exit 2
    fi

    # Create local backup directory.
    if [ -e $backup_dir/$source ]; then
        mkdir -p $backup_dir/$source
    fi

    # Run rsync.
    rsync $exclude -a --delete -e "ssh -i $ssh_key" $r_user@$r_host:$source/ $backup_dir/$source/

done

