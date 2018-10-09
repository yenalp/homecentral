#!/bin/bash

. "/vagrant/setup/helper-functions.sh"
. "/vagrant/setup/variables.sh"

        
SITE_DB_NAME="$DB_NAME"

# Make sure DB exists
if ! mysql -u root -p${DB_ROOT_PASS} -e "use $DB_NAME" >/dev/null 2>&1; then
    cl "Error: This script expects a database called $DB_NAME but that does not exist." -e
    log "save-db was called but $DB_NAME does not exist"
    exit
fi


# Dump db
DATE=`date +%Y-%m-%d:%H:%M`
FILE_NAME="${DB_NAME}_${DATE}_db.sql.gz"
BACKUP_PATH="${DB_DUMP_DIR}/${FILE_NAME}"

mysqldump --opt "$DB_NAME" | gzip > "$BACKUP_PATH"

if [ -f "$BACKUP_PATH" ]; then
    MSG="Backed up database to $FILE_NAME"
    cl "$MSG" -s
    log "$MSG"
else
    MSG="There was an error backing up the database."
    cl "$MSG" -e
    log "$MSG"
fi
