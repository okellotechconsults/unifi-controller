#!/bin/bash
set -e

# Start MongoDB in the background
mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db

# Wait for MongoDB to start
sleep 10

# Initialize MongoDB with UniFi user
/tmp/init-mongo.sh

# Start UniFi Controller
/usr/lib/unifi/bin/unifi.init start

# Keep the container running
tail -f /dev/null