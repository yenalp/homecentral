#!/usr/bin/env bash
import.require 'provision'

provision.libssl-dev_base.init() {
    provision.libssl-dev_base.__init() {
        import.useModule 'provision'
    }
    provision.libssl-dev_base.require() {
        provision.isInstalled 'libssl-dev'
        return $?
    }
}
