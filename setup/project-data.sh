#!/bin/bash

VAGRANT_BOOTSTRAP_PATH="/vagrant/setup"

. "$VAGRANT_BOOTSTRAP_PATH/modules/import.sh"
. "$VAGRANT_BOOTSTRAP_PATH/helper-functions.sh"
. "$VAGRANT_BOOTSTRAP_PATH/variables.sh"

import.init

# Set up mount on Bubbles
import.require 'provision.mount-folder'
import.useModule 'provision.mount-folder'

if [ "$SITES" != '' ] && [ "$SITES" != 'false' ] ; then

    for SITE in "$SITES"; do

        # Create folder to mount to
        if [ ! -d "/mnt/project-data" ]; then
            log "make project-data folder"
            mkdir /mnt/project-data
        fi

        # Mount bubbles
        if ! mount | grep bubbles > /dev/null; then
            cl "Mounting Bubbles"
            log "mount bubbles"
            mount -o vers=3 bubbles:/var/data/project-data /mnt/project-data
        fi

        # Create project folder
        if [ ! -d "/mnt/project-data/$PROJECT_NAME" ]; then
            cl "Creating project folder structure on Bubbles"
            log "create project folders on bubbles"
            su - vagrant -c "mkdir /mnt/project-data/$PROJECT_NAME"
            su - vagrant -c "mkdir /mnt/project-data/$PROJECT_NAME/sqldump/"
        fi

        if [ ! -d "/mnt/project-data/$PROJECT_NAME/$SITE" ]; then
            su - vagrant -c "mkdir /mnt/project-data/$PROJECT_NAME/$SITE"
            su - vagrant -c "mkdir /mnt/project-data/$PROJECT_NAME/$SITE/files/"
        fi


        if [ $MOUNT_FILES_BUBBLES != "false" ]; then

            log "set up the shared files folder on bubbles"

            # For Drupal install, enforce $FILES_DIR
            if [ "$FRAMEWORK" == "drupal7" -o "$FRAMEWORK" == "drupal8" ]; then
                FILES_DIR="/vagrant/www/sites/$SITE/files"
            fi

            # If there is a directory where we want our symlink then remove it
            if [ -d "$FILES_DIR" ] && [ ! -L "$FILES_DIR" ]; then

                cl "Files directory already exists, moving contents to mount location" -l

                # Copy any files already there to the mounted location
                su - vagrant -c "cp -Rvf $FILES_DIR/. /mnt/project-data/$PROJECT_NAME/$SITE/files"

                # And set permissions on this folder
                su - vagrant -c "chmod -R 777 $FILES_DIR"

                # And try and delete the thing
                su - vagrant -c "rm -rf $FILES_DIR"

            fi

            # Make the symlink
            if [ ! -L "$FILES_DIR" ]; then
                log "create symlink to shared files folder"
                ln -s "/mnt/project-data/$PROJECT_NAME/$SITE/files" "$FILES_DIR"
                # This is needed to allow Drupal to write to the files directory
                su - vagrant -c "chmod 777 $FILES_DIR"
            fi

        fi

    done
fi
