#!/bin/bash
# Min necessary for NGINX, Postgres, Ruby, Bundler and Rails.
sudo apt-get install -y libpq-dev nginx ruby2.3 rails bundler

# Backend dependencies

# Note regarding using apt-get for every needed package instead of Bundler.
# This is a non-DRY approach, and many packages may not be available (especially edge versions.)
# An example of it is ruby-active-model-serializers where apt-get only displays 0.9.3 when Fakktion needs 0.10.0.rc5
cd /home/$USER/Fakktion
# Check GemFile.lock for exactly what is being installed from https://rubygems.org/.
bundle install

# Prepare /var/www permissions for the upcomig steps.
sudo gpasswd -a "$USER" www-data
sudo chown -R "$USER":www-data /var/www
find /var/www -type f -exec chmod 0660 {} \;
sudo find /var/www -type d -exec chmod 2770 {} \;
