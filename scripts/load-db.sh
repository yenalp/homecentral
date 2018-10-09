#!/bin/bash

. "/vagrant/setup/helper-functions.sh"
. "/vagrant/setup/variables.sh"

# Make sure DB exists
if ! mysql -u root -p${DB_ROOT_PASS} -e "use $DB_NAME" >/dev/null 2>&1; then
    cl "Error: This script expects a database called $DB_NAME but that does not exist." -e
    exit
fi

# Find most recent dump
# TODO: Stop this line from producing an error when a dump does not exist
# Allow passing an arg for site folder name
MOST_RECENT=`find "$DB_DUMP_DIR" -type f -printf '%T@ %p\n' | grep "$DB_NAME" | sort -n | tail -1 | cut -f2- -d" "`

# Make sure there is a dump to import
if [ ${#MOST_RECENT} == 0 ]; then
  cl "No database dumps for this project have been created yet." -e
  exit
fi

FILE_NAME=${MOST_RECENT##*/}

importdb() {
    zcat $1 | mysql  "$DB_NAME"
    cl "$2 imported successfully" -s
}

if [[ $* == *-y* ]]; then # check for y flag
  importdb $MOST_RECENT $FILE_NAME
else

  # Are you sure?
  read -r -p $'\e[36m'"This will import $FILE_NAME over the top of your database. Are you sure? [y/N] "$'\e[0m' response
  case $response in
      [yY][eE][sS]|[yY])
          importdb $MOST_RECENT $FILE_NAME
          ;;
      *)
          exit
          ;;
  esac

fi
