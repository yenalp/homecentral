#!/usr/bin/env bash

import.require 'provision.mariadb103>base'
import.require 'provision.mysql-setup'
import.require 'provision.mariadb-setup'

provision.mariadb103.init() {
    provision.mariadb103.__init() {
        local __config_db_name="$1"
        import.useModule "provision.mariadb103_base"
        import.useModule 'provision.mysql-setup'
        import.useModule "provision.mariadb-setup"

        provision.mariadb103_base.addRepository "$@"
        provision.mariadb103_base.requireServer "$@"
        provision.mariadb103_base.requireClient "$@"
        provision.mariadb-setup.start "$@"

        provision.mysql-setup.myCnf "$@"
        provision.mysql-setup.createDb "${__config_db_name}"

        provision.mariadb-setup.updateMariaDbCnf "$@"

        provision.mysql-setup.usersHost "$@"
    }

}
