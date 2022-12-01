#! /bin/bash

# Example usage: /scripts/wo-migrate.sh prod.com dev.com

SOURCE_SITE=$1
SOURCE_SITE_ROOT="/var/www/$SOURCE_SITE/htdocs"

DEST_SITE=$2
DEST_SITE_ROOT="/var/www/$DEST_SITE/htdocs"

# Add option to migrate specific backup. If not specified, use latest backup.
BACKUP_DATE=$3
BACKUP="/opt/backups/$SOURCE_SITE/$BACKUP_DATE"

# If no source domain, bail.
if test -z "$SOURCE_SITE"; then
	echo "❗No domain informed!"
	exit 1

	# If no config, bail.
	if [ ! -e "/var/www/$SOURCE_SITE/wp-config.php" ]; then
		echo "❗️$SOURCE_SITE does not appear to be a valid WordPress!"
		exit 1
	fi

	# If no backup, bail
	if [ ! -e "$BACKUP".sql ]; then
		echo "❗️$BACKUP.sql does not appear to be located in $BACKUP!"
		exit 1
	fi
fi

# If no destination domain, bail.
if test -z "$DEST_SITE"; then
	echo "❗No domain informed!"
	exit 1

	# If no config, bail.
	if [ ! -e "/var/www/$DEST_SITE/wp-config.php" ]; then
		echo "❗️$DEST_SITE does not appear to be a valid WordPress!"
		exit 1
	fi
fi

cd "$DEST_SITE_ROOT" || exit

echo "␡ Delete the wp-content $DEST_SITE..."
rm -rf wp-content/plugins/ wp-content/themes/ wp-content/uploads/

sleep 1

echo "👉 rsync $SOURCE_SITE_ROOT/wp-content/ to $DEST_SITE_ROOT/wp-content..."
rsync -avz --delete "$SOURCE_SITE_ROOT"/wp-content/ "$DEST_SITE_ROOT"/wp-content/

sleep 1

echo "♻️ Resetting the database for $DEST_SITE..."
wp db reset --yes --allow-root

sleep 1

echo "⬇️ Importing the database from $SOURCE_SITE..."
wp db import "$BACKUP".sql --allow-root

sleep 1

echo "🔎 Searching and replacing $SOURCE_SITE with $DEST_SITE..."
wp search-replace "$SOURCE_SITE" "$DEST_SITE" --allow-root

sleep 1

wp cache flush --allow-root

echo "$SOURCE_SITE to $DEST_SITE migration complete 🤘"

exit 0
