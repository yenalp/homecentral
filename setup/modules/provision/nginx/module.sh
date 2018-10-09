#!/usr/bin/env bash

import.require 'provision.nginx>base'

provision.nginx.init() {
    provision.nginx.__init() {
        local __config_type="$1"
        local __config_name="$2"

        import.useModule "provision.nginx_base"
        provision.nginx_base.require "$@"
        provision.nginx_base.createSiteConfig "$@"
    }
}
