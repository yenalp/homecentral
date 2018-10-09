#!/usr/bin/env bash

import.require 'provision.mariadb101>base'
import.require 'provision.mysql-setup'
import.require 'provision.mariadb-setup'

provision.mariadb101.init() {
    provision.mariadb101.__init() {
        local __config_db_name="$1"
        import.useModule "provision.mariadb101_base"
        import.useModule 'provision.mysql-setup'
        import.useModule "provision.mariadb-setup"

        provision.mariadb101_base.addRepository "$@"
        provision.mariadb101_base.requireServer "$@"
        provision.mariadb101_base.requireClient "$@"
        provision.mariadb-setup.start "$@"

        provision.mysql-setup.myCnf "$@"
        provision.mysql-setup.createDb "${__config_db_name}"

        provision.mariadb-setup.updateMariaDbCnf "$@"

        provision.mysql-setup.usersHost "$@"
    }

}
