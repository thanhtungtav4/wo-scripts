#! /bin/bash

# Example usage: /scripts/wo-import.sh site.com 202208191441

SITE=$1
SITE_ROOT="/var/www/$SITE/htdocs"

BACKUP_DATE=$2
BACKUP="/var/www/$SITE/import/$BACKUP_DATE"

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
	if [ ! -e "$BACKUP/$SITE".sql ]; then
		echo "❗️$SITE.sql does not appear to be located in $BACKUP!"
		exit 1
	fi
fi

cd "$SITE_ROOT" || exit

echo "␡ Delete the wp-content $SITE..."
rm -rf wp-content/plugins/ wp-content/themes/ wp-content/uploads/

sleep 1

echo "⬇️ Import files from $SITE..."
tar -xf "$BACKUP/$SITE".tar.gz

sleep 1

echo "♻️ Resetting the database for $SITE..."
wp db reset --yes --allow-root

sleep 1

echo "⬇️ Importing the database from $SITE..."
wp db import "$BACKUP/$SITE".sql --allow-root

sleep 1

wp cache flush --allow-root

sleep 1

sudo chown -R www-data:www-data ./ && sudo find . -type f -exec chmod 644 {} + && sudo find . -type d -exec chmod 755 {} +

sleep 1

echo "$SITE import complete 🤘"

exit 0
