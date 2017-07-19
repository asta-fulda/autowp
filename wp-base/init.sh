#!/bin/bash
#
# Init script to run some maintenance and container initialization
# Refer to https://developer.wordpress.org/cli/ for more information on
# the usage of wp-cli.
#
set -e

# Alias for WP-cli to include arguments that we want to use everywhere
shopt -s expand_aliases
alias wp="wp --path=/var/www/html --allow-root"

### Configuration and Installation ###
#
# Config creation
# - Make sure the config is created -> overrides all changes at container reboot
wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOST --dbprefix=$WP_PREFIX --locale=$wp_locale
# Make sure that the instance is installed
# This will either:
# - 1 - run the installation process and create all tables in database
# - 2 - Skip with a warning, if wp is already installed/found in database
if [ ! $(wp core is-installed) ]; then
   if [ -e /var/www/html/init/database.sql ]; then
      wp db import /var/www/html/init/database.sql
   else
      wp core install --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --skip-email
   fi
else
   wp core update --version=$WP_BUILD_VERSION --locale=$WP_BUILD_LOCALE --force
   # Run the database update procedure in case the container got updated
   # and the db is therefore outdated
   wp core update-db
fi

### Plugin installation and maintenance ###
#
# Define here all plugins, that should be shiped within the container
# Recommended way is to define a specific version and to update it here if necessary
# If you specify '--activate' option it will make sure the plugin will be
# activated after installation

if [ -e /var/www/html/init/plugins.txt ]; then
   cat /var/www/html/init/plugins.txt |
   while read plugin version; do
      if [ ! $(wp plugin is-installed) ]; then
         # Install new plugins and force an overwrite
         # The '--force' option reinstalles (updates) all plugins 
         wp plugin install $plugin --version=$version --activate
      else
         # Update present plugins that are persistet
         # This is important if a plugin get's installed 
         wp plugin update $plugin --version=$version
      fi
   done
fi

# Output information of all installed plugins
wp plugin status

# < Theme >

# < / Theme >

### Database operations ###
#
# Repair and Optimize the database on every startup to ensure 
# an existing database will always be consistent and optimized
wp db repair
wp db optimize
# Final check of the database
wp db check