#!/bin/bash
# TODO comments
>> /etc/nginx/sites-available/default
cat fakktion.conf >> /etc/nginx/sites-available/default
sudo service nginx restart