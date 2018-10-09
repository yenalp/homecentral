#!/usr/bin/env bash

VAGRANT_BOOTSTRAP_PATH="/vagrant/setup"

. "$VAGRANT_BOOTSTRAP_PATH/modules/import.sh"
. "$VAGRANT_BOOTSTRAP_PATH/helper-functions.sh"
. "$VAGRANT_BOOTSTRAP_PATH/variables.sh"

import.init

# Refresh SSL if necessary
import.require 'provision.ssl'
import.useModule 'provision.ssl'

# Set up mount on Bubbles
#. /vagrant/setup/project-data.sh
. "$VAGRANT_BOOTSTRAP_PATH/project-data.sh"

