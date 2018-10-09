#!/usr/bin/env bash

import.require 'provision.apache>base'

provision.apache.init() {
    provision.apache.__init() {
        local __config_type="$1"
        local __config_name="$2"

        import.useModule "provision.apache_base"
        provision.apache_base.require "$@"
        provision.apache_base.createVhostConfig "$@"
        provision.apache_base.enableModules "$@"
    }
}
