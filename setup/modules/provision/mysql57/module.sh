#!/usr/bin/env bash

import.require 'provision.mysql57>base'
import.require 'provision.mysql-setup'

provision.mysql57.init() {
    provision.mysql57.__init() {
        local __config_db_name="$1"
        import.useModule "provision.mysql57_base"
        import.useModule 'provision.mysql-setup'

        provision.mysql57_base.requireServer "$@"
        provision.mysql57_base.requireClient "$@"
        provision.mysql57_base.start "$@"

        provision.mysql-setup.myCnf "$@"
        provision.mysql-setup.createDb "${__config_db_name}"

        provision.mysql57_base.updateMysqlCnf "$@"

        provision.mysql-setup.usersHost "$@"

    }

}
