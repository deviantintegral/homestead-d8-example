#!/bin/bash

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.
#
# If you have user-specific configurations you would like
# to apply, you may also create user-customizations.sh,
# which will be run after this script.

# The hostname is set on first boot, but avahi doesn't pick it up until a
# restart. This needs to be fixed upstream
sudo systemctl restart avahi-daemon

# Install Drupal for this demo. For existing sites, you could grab a database
# and import that instead.
cd code
export PATH=$PATH:$(pwd)/vendor/bin

mount | grep code

for i in {1..3}
do
  echo "Install #$i"
  PROVIDER=$(cat provider)
  SYNC_TYPE=$(cat sync-type)
  echo -n "$PROVIDER,$SYNC_TYPE," >> /vagrant/results.csv
  /usr/bin/time -o /vagrant/results.csv -a -f '%U,%S,%E,%P,%I,%O' \
    drush -y si \
    --db-url=mysql://homestead:secret@localhost/homestead \
    --site-name "Homestead example site" \
    standard
done
