#!/bin/bash

# Modify bash prompt
import.require 'provision.bashrc'
import.useModule 'provision.bashrc'

# Set up mount on Bubbles
#import.require 'provision.mount-folder'
#import.useModule 'provision.mount-folder'

# Modify motd
import.require 'provision.motd'
import.useModule 'provision.motd'

# Allow vagrant user to read apache2 log files
adduser vagrant adm

# setup symbolic link
__html="/var/www/html"
__html_default_files="${FILES_DIR}"
__html_org="/var/www/html.org"

if [ ! -d "${__html_org}" ]; then
    mv "${__html}" "${__html_org}" || {
    "failed to backup html directory ... " -e
}
fi

if [ ! -L "${__html}" ]; then
    ln -s "${WEBROOT}" "${__html}" || {
    cl "failed to create symbolic link ... " -e
}
fi

cd /vagrant
