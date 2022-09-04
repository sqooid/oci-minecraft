#!/bin/bash
set -x

BUCKET="https://objectstorage.${region}.oraclecloud.com${setup_request}"

sleep 30s

mkdir -p /temp && cd /temp
curl -s "$${BUCKET}user-data-lazy.sh" -o user-data-lazy.sh
chmod +x user-data-lazy.sh
./user-data-lazy.sh > user-data.log 2>&1
