#! /bin/bash

# Example usage: /scripts/wo-import.sh site.com 202208191441

SITE=$1
SITE_ROOT="/var/www/$SITE/htdocs"

BACKUP_DATE=$2
BACKUP="/var/www/$SITE/backup/$BACKUP_DATE/$SITE"

# If no source domain, bail.
if test -z "$SITE"; then
	echo "❗No domain informed!"
	exit 1

	# If no config, bail.
	if [ ! -e "/var/www/$SITE/wp-config.php" ]; then
		echo "❗️$SITE does not appear to be a valid WordPress!"
		exit 1
	fi

	# If no backup, bail
	if [ ! -e "$BACKUP".sql ]; then
		echo "❗️$BACKUP.sql does not appear to be located in $BACKUP!"
		exit 1
	fi
fi

cd "$SITE_ROOT" || exit

echo "␡ Delete the wp-content $SITE..."
rm -rf wp-content/plugins/ wp-content/themes/ wp-content/uploads/

echo "⬇️ Import files from $SITE..."
tar -xf "$BACKUP".tar.gz

echo "♻️ Resetting the database for $SITE..."
wp db reset --yes --allow-root

echo "⬇️ Importing the database from $SITE..."
wp db import "$BACKUP".sql --allow-root

wp cache flush --allow-root;

exit 0
