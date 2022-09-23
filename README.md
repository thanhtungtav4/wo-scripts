# wo-scripts

Collection of scripts to use with WordOps.

## What's going on here?

- Checks if there’s a WordPress site installed
- Creates a backup path in /var/www/yourdomain.com/backup/
- Backs up files excluding files listed in exclusions.txt
- Backs up wp-config.php
- Backs up the database

## Getting started

```bash
# Create /scripts directory
mkdir /scripts && cd /scripts

# Clone repository into /scripts
git clone https://code.superrad.dev/superrad/wo-scripts.git
```

### Example Backup

```bash
/scripts/wo-backup/wo-backup.sh yourdomain.com
```

### Example Import

1. Create a new site in WordOps or have use an existing site in WordOps. Keep in mind that this import will delete plugins, themes, and uploads as well as reset the database. If you don't want to lose anything with the site you're importing into, backup first.
2. Copy the backup that you're importing into the desired sites backup directory (var/www/yoursite.com/backup). In this example our backup will be labeled '202208221423'.
3. Next, run the following.

	```bash
	/scripts/wo-backup/wo-import.sh yourdomain.com 202208221423
	```

### Example Migrate

1. Backup your source site using `wo-backup.sh`. For this example we'll call the source site "Staging".
2. Create your destination site or use one that's already created. For this example we'll call the destination site "Prod".
3. Next we're going to be migrating Staging to Prod.
	```bash
 	/scripts/wo-backup/wo-migrate.sh staging.com prod.com 202208221423
	```

### To do

- Multisite support
