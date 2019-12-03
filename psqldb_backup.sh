#!/bin/bash

if [ $# -lt 5 ]; then
    echo "usage: $0 <db_pass> <db_owner> <db_name> <backup_path> <tab1...tabN>"
    exit 1
fi

if [ ! -d $4 ]; then
    echo "directory $4 does not exist!"
    exit 2
fi

for ((i=0; i<=$#; i++)); do
    if [ $i -gt 4 ]; then
        PGPASSWORD=$1 psql -U $2 -d $3 -c \
        "\copy ${!i} to stdout with (format csv, header true, delimiter ',');" \
        > $4/${!i}.csv && tar czf ${!i}.$(date '+%Y%m%d_%H%M%S').csv.tar.gz $4/${!i}.csv
        #echo "${!i}"
    fi
done
exit 0
#PGPASSWORD="A19-S1l1t" psql -U "postgres" -d "rashid_cisc7510x" -c "\copy divtab to stdout with (format csv, header true, delimiter ,);" > divtab.csv
