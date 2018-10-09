#!/usr/bin/env bash

import.require 'provision.mysql56>base'
import.require 'provision.mysql-setup'

provision.mysql56.init() {
    provision.mysql56.__init() {
        local __config_db_name="$1"
        import.useModule "provision.mysql56_base"
        import.useModule 'provision.mysql-setup'

        provision.mysql56_base.addRepository "$@"
        provision.mysql56_base.requireServer "$@"
        provision.mysql56_base.requireClient "$@"
        provision.mysql56_base.start "$@"

        provision.mysql-setup.myCnf "$@"
        provision.mysql-setup.createDb "${__config_db_name}"

        provision.mysql56_base.updateMysqlCnf "$@"

        provision.mysql-setup.usersHost "$@"

    }

}
