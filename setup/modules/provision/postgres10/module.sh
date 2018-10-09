#!/usr/bin/env bash

import.require 'provision.postgres10>base'

provision.postgres10.init() {
    provision.postgres10.__init() {
        local __config_db_name="$1"
        import.useModule "provision.postgres10_base"

        provision.postgres10_base.addRepository "$@"
        provision.postgres10_base.requireServer "$@"
        provision.postgres10_base.addUser "$@"
        provision.postgres10_base.start "$@"
        provision.postgres10_base.createDb "${__config_db_name}"
    }
}
