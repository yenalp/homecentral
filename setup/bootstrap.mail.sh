#!/bin/bash
VAGRANT_BOOTSTRAP_PATH="/vagrant/setup"

. "$VAGRANT_BOOTSTRAP_PATH/modules/import.sh"
. "$VAGRANT_BOOTSTRAP_PATH/helper-functions.sh"
. "$VAGRANT_BOOTSTRAP_PATH/variables.sh"

import.init

##################################
#          Provisioning          #
##################################

# # Don't ask for anything
export DEBIAN_FRONTEND=noninteractive

# Setup postfix
import.require 'provision.postfix'
import.useModule 'provision.postfix'

# Setup mailutils
import.require 'provision.mailutils'
import.useModule 'provision.mailutils'
