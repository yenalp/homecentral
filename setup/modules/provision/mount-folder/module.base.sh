#!/usr/bin/env bash

import.require 'provision'
import.require 'provision.nfs-common'

provision.mount-folder_base.init() {
    provision.mount-folder_base.__init() {
        import.useModule 'provision'

        # Ensure nfs client is installed
        import.useModule 'provision.nfs-common'
    }

    provision.mount-folder_base.makeProjectData() {
        local __project_data="/mnt/project-data"
        if [ -d "${__project_data}" ]; then
            return 0
        else
            mkdir /mnt/project-data || {
            cl "failed to create ${__project_data} ... " -e
            return 1
        }
        fi
        return 0
    }

    provision.mount-folder_base.mountBubbles() {
        if mount | grep bubbles > /dev/null; then
            return 0
        else
            mount -o vers=3 bubbles:/var/data/project-data /mnt/project-data || {
            cl "failed to mount bubbles ... " -e
            return 1
        }
        fi
        return 0
    }

    provision.mount-folder_base.createProjectFolder() {
        if [ -d "/mnt/project-data/${PROJECT_NAME}" ]; then
            return 0
        else

            su - vagrant -c "mkdir /mnt/project-data/${PROJECT_NAME}" || {
            cl "failed to create ${PROJECT_NAME} ... " -e
            return 1
        }

            su - vagrant -c "mkdir /mnt/project-data/${PROJECT_NAME}/sqldump" || {
            cl "failed to create ${PROJECT_NAME}/sqldump ... " -e
            return 1
        }

            su - vagrant -c "mkdir /mnt/project-data/${PROJECT_NAME}/files" || {
            cl "failed to create ${PROJECT_NAME}/files ... " -e
            return 1
        }
        fi
        return 0
    }

}
