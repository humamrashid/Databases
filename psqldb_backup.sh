#!/bin/bash

if [ $# -lt 5 ]; then
    echo "usage: $0 <db_pass> <db_owner> <db_name> <backup_dir> <tab1...tabN>"
    exit 1
fi

if [ !( -d $4) ]; then
    mkdir -p $4
fi

for ((i=0; i<$#; i++)); do
    echo "$i"
done
exit 0
