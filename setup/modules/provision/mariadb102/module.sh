#!/usr/bin/env bash

import.require 'provision.mariadb102>base'
import.require 'provision.mysql-setup'
import.require 'provision.mariadb-setup'

provision.mariadb102.init() {
    provision.mariadb102.__init() {
        local __config_db_name="$1"
        import.useModule "provision.mariadb102_base"
        import.useModule 'provision.mysql-setup'
        import.useModule "provision.mariadb-setup"

        provision.mariadb102_base.addRepository "$@"
        provision.mariadb102_base.requireServer "$@"
        provision.mariadb102_base.requireClient "$@"
        provision.mariadb-setup.start "$@"

        provision.mysql-setup.myCnf "$@"
        provision.mysql-setup.createDb "${__config_db_name}"

        provision.mariadb-setup.updateMariaDbCnf "$@"

        provision.mysql-setup.usersHost "$@"
    }

}
