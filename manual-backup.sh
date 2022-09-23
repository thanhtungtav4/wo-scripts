#! /bin/bash

/scripts/wo-scripts/wo-backup.sh blog.sixteenbit.com;

sleep 1;

/scripts/wo-scripts/wo-backup.sh carewise360.com;

sleep 1;

/scripts/wo-scripts/wo-backup.sh tfcu.infosurv.com;

sleep 1;

/scripts/wo-scripts/wo-backup.sh healthgrades.infosurv.com;

sleep 1;

echo "🔄 Backing up files to Google Drive..."
gdrive push -quiet -destination Backups /opt/backups/*;
