#!/bin/bash
set -e

mongosh admin <<EOF
db.getSiblingDB("admin").createUser({
  user: "unifi",
  pwd: "unifi_password",
  roles: [
    { role: "dbOwner", db: "unifi" }
  ]
});

db.getSiblingDB("unifi").createCollection("init");
EOF
