#!/usr/bin/env bash

import.require 'provision.libgeoip-dev>base'

provision.libgeoip-dev.init() {
    provision.libgeoip-dev.__init() {
        import.useModule "provision.libgeoip-dev_base"
        provision.libgeoip-dev_base.require "$@"
    }
}
