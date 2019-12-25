#!/bin/bash
# Humam Rashid

# psqldb_backup: a script for UNIX-like systems running bash to archive and
# encrypt Postgresql database tables. Only works with psql and GnuPG. Further,
# the script assumes GnuPG has been configured and a key pair already generated.
# The files are backed up as CSV instead of any DBMS-specific format.

# Works on one database at a time but any number of tables from the database can
# be supplied as arguments. First 5 arguments to the script are database owner
# password, database owner name, database name, backup path and recipient
# user-id (i.e., email address), respectively. Any arguments thereafter are
# considered to be the names of tables from the database. Each encrypted archive
# for a particular table is saved in the backup directory with the original name
# followed by a timestamp and ending '.tar.gz.gpg'.

if [ $# -lt 6 ]; then
    echo "usage: $0 <db_pass> <db_owner> <db_name> <backup_path> <recipient> <tab1...tabN>"
    exit 1
fi
if [ ! -d $4 ]; then
    echo "directory $4 does not exist!"
    exit 2
fi
cd $4
for ((i=6; i<=$#; i++)); do
    PGPASSWORD=$1 psql -U $2 -d $3 -c \
    "\copy ${!i} to stdout with (format csv, header true, delimiter ',');" > ${!i}.csv && tar cz \
    ${!i}.csv | gpg --encrypt --recipient $5 > ${!i}.$(date '+%Y%m%d_%H%M%S').tar.gz.gpg && rm \
    ${!i}.csv
done
cd - > /dev/null
exit 0

# EOF.
