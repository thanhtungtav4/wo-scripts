#! /bin/bash

# Example usage: /scripts/wo-backup.sh thedomain.com

SITE=$1
DATE_FORM=$(date -d "today" +"%Y%m%d%H%M")
BACKUP_DIR="/var/www/$SITE/backup/"
BACKUP_PATH="/var/www/$SITE/backup/$DATE_FORM"
SITE_ROOT="/var/www/$SITE/htdocs"
DAYSKEEP=7

if test -z "$SITE"; then
	echo "❗No domain informed!"
	exit 1
fi

if [ ! -e "/var/www/$SITE/wp-config.php" ]; then
	echo "❗️$SITE does not appear to be a valid WordPress!"
	exit 1
fi

# Make sure the backup folder exists
mkdir -p "$BACKUP_PATH"

# Delete old backups locally over DAYSKEEP days old
find "$BACKUP_DIR" -type d -mtime +$DAYSKEEP -exec rm -rf {} \;

cd "$SITE_ROOT" || exit

echo "🔄 Backing up files to $BACKUP_PATH..."
tar -czf "$BACKUP_PATH/$SITE.tar.gz" --exclude-from="/scripts/wo-backup/exclusions.txt" -C "$SITE_ROOT" .

# Backup WordPress config file
cp "/var/www/$SITE/wp-config.php" "$BACKUP_PATH"

echo "🔄 Backing up WordPress database..."

wp db export "$BACKUP_PATH/$SITE".sql \
	--single-transaction \
	--quick \
	--lock-tables=false \
	--allow-root \
	--skip-themes \
	--skip-plugins \
	--quiet

echo "✅ $SITE backup complete."

exit 0
