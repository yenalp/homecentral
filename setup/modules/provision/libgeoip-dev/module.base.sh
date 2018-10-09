#!/usr/bin/env bash
import.require 'provision'

provision.libgeoip-dev_base.init() {
    provision.libgeoip-dev_base.__init() {
        import.useModule 'provision'
    }
    provision.libgeoip-dev_base.require() {
        provision.isInstalled 'libgeoip-dev'
        return $?
    }
}
