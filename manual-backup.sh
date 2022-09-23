#! /bin/bash

/scripts/wo-backup/wo-backup.sh blog.sixteenbit.com;

sleep 1;

/scripts/wo-backup/wo-backup.sh carewise360.com;

sleep 1;

/scripts/wo-backup/wo-backup.sh tfcu.infosurv.com;

sleep 1;

/scripts/wo-backup/wo-backup.sh healthgrades.infosurv.com;

sleep 1;

gdrive push -quiet -destination Backups /opt/backups/*;
