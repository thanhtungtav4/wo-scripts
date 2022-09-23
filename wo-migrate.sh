#! /bin/bash

# Example usage: /scripts/wo-migrate.sh prod.com dev.com 202208191441

SOURCE_SITE=$1
SOURCE_SITE_ROOT="/var/www/$SOURCE_SITE/htdocs"

DEST_SITE=$2
DEST_SITE_ROOT="/var/www/$DEST_SITE/htdocs"

BACKUP_DATE=$3
BACKUP="/var/www/$SOURCE_SITE/backup/$BACKUP_DATE/$SOURCE_SITE"

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

echo "⬇️ Import files from $SOURCE_SITE..."
tar -xf "$BACKUP".tar.gz

echo "♻️ Resetting the database for $DEST_SITE..."
wp db reset --yes --allow-root

echo "⬇️ Importing the database from $SOURCE_SITE..."
wp db import "$BACKUP".sql --allow-root

echo "🔎 Searching and replacing $SOURCE_SITE with $DEST_SITE..."
wp search-replace "$SOURCE_SITE" "$DEST_SITE" --allow-root

wp cache flush --allow-root;

exit 0
