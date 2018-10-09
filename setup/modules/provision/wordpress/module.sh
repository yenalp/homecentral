#!/usr/bin/env bash

import.require 'provision.wordpress>base'

provision.wordpress.init() {
    provision.wordpress.__init() {
                local __config_db_name="$1"
        import.useModule "provision.wordpress_base"
        provision.wordpress_base.installWordpressCli "$@"
        provision.wordpress_base.installWordpress "${__config_db_name}"
    }
}
