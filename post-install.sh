#! /bin/bash

DOM=$1
if test -z $DOM; then
	echo "ERROR: no domain informed!"
	exit 1
fi

if [ ! -e "/var/www/${DOM}/wp-config.php" ]; then
	echo "ERROR: ${DOM} does not appear to be a valid WordPress!"
	exit 1
fi

cd "/var/www/${DOM}/htdocs" || exit 1

### Install plugins from official repository
wp plugin install autodescription cloudflare google-site-kit limit-login-attempts-reloaded mailgun two-factor wordpress-importer --activate --allow-root

sleep 1

# Install Advanced Custom Fields Pro if not installed
echo "Installing Advanced Custom Fields Pro..."
wp plugin install https://files.superrad.dev/wordpress/plugins/advanced-custom-fields-pro.zip --activate --allow-root

sleep 1

# Install Gravity Forms if not installed
echo "Installing Gravity Forms..."
wp plugin install https://files.superrad.dev/wordpress/plugins/gravityforms.zip --activate --allow-root

sleep 1

# Install WordPress Environments if not installed
echo "Installing WordPress Environments..."
wp plugin install https://files.superrad.dev/wordpress/plugins/wp-environments.zip --activate --allow-root

sleep 1

# Install Super Rad Login if not installed
echo "Installing Super Rad Login..."
wp plugin install https://files.superrad.dev/wordpress/plugins/superrad-login.zip --activate --allow-root

sleep 1

# Set Timezone to New York
wp option update timezone_string "America/New_York" --allow-root

sleep 1

# Update permalink structure
wp option update permalink_structure "/%postname%/" --allow-root

sleep 1

# Set permissions
sudo chown -R www-data:www-data ./ && sudo find . -type f -exec chmod 644 {} + && sudo find . -type d -exec chmod 755 {} +

echo "Super Rad post install complete 🤘"

exit 0
