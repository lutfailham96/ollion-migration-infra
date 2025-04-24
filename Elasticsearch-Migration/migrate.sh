#!/bin/bash

EXISTING_CLUSTER="https://existing-es.gcp.sample-server.com"
TARGET_CLUSTER="https://target-es.aws.sample-server.com"

# create full snapshots
curl -X PUT "${EXISTING_CLUSTER}/_snapshot/my_backup/full_snapshot?wait_for_completion=true"

# lets assume that the snapshot located on /mnt/es-backup/
rsync -avz /mnt/es-backup/ user@destination-vm:/mnt/es-backup/

# register repository on new cluster
curl -X PUT "${TARGET_CLUSTER}/_snapshot/my_backup" -H "Content-Type: application/json" -d '{
  "type": "fs",
  "settings": {
    "location": "/mnt/es-backup"
  }
}'

# reestore snapshots
curl -X POST "${TARGET_CLUSTER}/_snapshot/my_backup/full_snapshot/_restore"
