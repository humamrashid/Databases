#!/bin/bash

# Humam Rashid
# CISC 7510X, Fall 2019.

# psqldb_backup: a script for UNIX-like systems running bash to archive and
# encrypt Postgresql database tables. Only works with psql and GnuPG. Further,
# the script assumes GnuPG has been configured and a key pair already generated
# for the recipient. Works on one database at a time but any number of tables
# from the database can be supplied as arguments. First 5 arguments to the
# script are database owner password, database owner name, database name, backup
# path and recipient user-id (i.e., email address).

if [ $# -lt 6 ]; then
    echo "usage: $0 <db_pass> <db_owner> <db_name> <backup_path> <recipient>"\
        "<tab1...tabN>"
    exit 1
fi

if [ ! -d $4 ]; then
    echo "directory $4 does not exist!"
    exit 2
fi

for ((i=0; i<=$#; i++)); do
    if [ $i -gt 5 ]; then
        PGPASSWORD=$1 psql -U $2 -d $3 -c \
        "\copy ${!i} to stdout with (format csv, header true, delimiter ',');" \
        > $4/${!i}.csv && \
        tar cz $4/${!i}.csv | gpg --encrypt --recipient $5 \
        > $4/${!i}.$(date '+%Y%m%d_%H%M%S').tar.gz.gpg && \
        rm $4/${!i}.csv
    fi
done
exit 0

# EOF.
