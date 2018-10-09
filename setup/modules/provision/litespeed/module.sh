#!/usr/bin/env bash

import.require 'provision.litespeed>base'

provision.litespeed.init() {
    provision.litespeed.__init() {
        local __config_type="$1"
        local __config_name="$2"

        import.useModule "provision.litespeed_base"
        provision.litespeed_base.require "$@"
        provision.litespeed_base.createSiteConfig "$@"
        # provision.litespeed_base.enableModules "$@"
    }
}
