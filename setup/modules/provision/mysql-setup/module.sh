#!/usr/bin/env bash

import.require 'provision.mysql-setup>base'

provision.mysql-setup.init() {
    provision.mysql-setup.__init() {
        import.useModule "provision.mysql-setup_base"
    }

    # Flushing the privileges
    provision.mysql-setup.flushPrivileges() {
        provision.mysql-setup_base.flushPrivileges "$@"
    }

    # Adding user grants
    provision.mysql-setup.usersHost() {
        provision.mysql-setup_base.usersHost "$@"
    }
    # Adding user grants
    provision.mysql-setup.createDb() {
        provision.mysql-setup_base.createDb "$@"
    }

    # Adding user grants
    provision.mysql-setup.myCnf() {
        provision.mysql-setup_base.myCnf "$@"
    }

}
