#!/bin/bash

. "/vagrant/setup/helper-functions.sh"
. "/vagrant/setup/variables.sh"

function emptydb {
  mysqldump --add-drop-table "$DB_NAME" | grep "DROP TABLE" | mysql "$DB_NAME"
  cl "$DB_NAME is now empty"
}

# Are you sure?
read -r -p $'\e[36m'"This will delete every table in the $DB_NAME database. Are you sure you want to continue? [y/N] "$'\e[0m' response
case $response in
    [yY][eE][sS]|[yY])
        emptydb
        ;;
    *)
        exit
        ;;
esac
