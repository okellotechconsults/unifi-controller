#!/bin/bash
set -e

mongosh <<EOF
use admin
db.auth(
  "root",
  "your_root_password"
)

use unifi
db.createUser({
  user: "unifi",
  pwd: "your_unifi_password",
  roles: [
    { role: "dbOwner", db: "unifi" }
  ]
})
EOF
