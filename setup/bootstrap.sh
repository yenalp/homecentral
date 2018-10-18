#!/bin/bash

VAGRANT_BOOTSTRAP_PATH="/vagrant/setup"

. "$VAGRANT_BOOTSTRAP_PATH/modules/import.sh"
. "$VAGRANT_BOOTSTRAP_PATH/helper-functions.sh"
. "$VAGRANT_BOOTSTRAP_PATH/variables.sh"

import.init

##################################
#          Provisioning          #
##################################

# Prepare apt and user for provisioning
. "$VAGRANT_BOOTSTRAP_PATH/pre.provisioning.sh"

# Setup timezone
import.require 'provision.timezone'
import.useModule 'provision.timezone'

# Setup unzip
import.require 'provision.unzip'
import.useModule 'provision.unzip'

# Setup imagemagick
import.require 'provision.imagemagick'
import.useModule 'provision.imagemagick'

# Setup build-essential
import.require 'provision.build-essential'
import.useModule 'provision.build-essential'

# Setup libsqlite3-dev
import.require 'provision.libsqlite3-dev'
import.useModule 'provision.libsqlite3-dev'

# Setup git
import.require 'provision.git'
import.useModule 'provision.git'

# ======= Webserver =======
import.require "provision.apache"
import.useModule "provision.apache"

# ======= PHP Version =======
import.require "provision.php72"
import.useModule "provision.php72"

# ======= Database Type and Version =======
import.require "provision.mariadb103"
import.useModule "provision.mariadb103" "$DB_NAME"

# Setup composer
import.require 'provision.composer'
import.useModule 'provision.composer'

cl "$VAGRANT_BOOTSTRAP_PATH/bootstrap.$CMS_SPECIFIC_BOOTSTRAP.sh";

# CMS specific provisioning
if [ -f "$VAGRANT_BOOTSTRAP_PATH/bootstrap.$CMS_SPECIFIC_BOOTSTRAP.sh" ]; then
    cl "Running provisioning script for bootstrap.$CMS_SPECIFIC_BOOTSTRAP.sh" -l
    . "$VAGRANT_BOOTSTRAP_PATH/bootstrap.$CMS_SPECIFIC_BOOTSTRAP.sh"
fi

# Prepare apt and user for provisioning
. "$VAGRANT_BOOTSTRAP_PATH/post.provisioning.sh"
