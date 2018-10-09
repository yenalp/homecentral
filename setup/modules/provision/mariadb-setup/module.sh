#!/usr/bin/env bash

import.require 'provision.mariadb-setup>base'

provision.mariadb-setup.init() {
    provision.mariadb-setup.__init() {
        import.useModule "provision.mariadb-setup_base"
    }

    # Flushing the privileges
    provision.mariadb-setup.updateMariaDbCnf() {
        provision.mariadb-setup_base.updateMariaDbCnf "$@"
    }

    # Adding user grants
    provision.mariadb-setup.start() {
        provision.mariadb-setup_base.start "$@"
    }
    # Adding user grants
    provision.mariadb-setup.restart() {
        provision.mariadb-setup_base.restart "$@"
    }

    # Adding user grants
    provision.mariadb-setup.reload() {
        provision.mariadb-setup_base.reload "$@"
    }

    # Adding user grants
    provision.mariadb-setup.stop() {
        provision.mariadb-setup_base.stop "$@"
    }

}
