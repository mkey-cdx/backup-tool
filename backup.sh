#!/bin/bash

# ==============================================================================
# Rsync backup tool
#
# Maintainer: Mickaël Coiraton
# Version 0.0.1
# Updated: 18 December 2016
#
# This is a simple backup tool based on rsync.
# It creates a full backup and a differential backup for each day of a week.
#
# ==============================================================================

DAY=$(date +%A)

if [ -e /location/to/backup/incr/$DAY ] ; then
  rm -fr /location/to/backup/incr/$DAY
fi

rsync -a --delete --inplace --backup --backup-dir=/location/to/backup/incr/$DAY /folder/to/backup/ /location/to/backup/full/ &> /dev/null
