#!/bin/bash
set -e

mongosh <<EOF
use admin
db.auth(
  process.env.MONGO_INITDB_ROOT_USERNAME,
  process.env.MONGO_INITDB_ROOT_PASSWORD
)

use unifi
db.createUser({
  user: process.env.MONGO_USER,
  pwd: process.env.MONGO_PASS,
  roles: [
    { role: "dbOwner", db: "unifi" }
  ]
})
EOF
