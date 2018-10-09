#!/usr/bin/env bash
import.require 'provision'

provision.zlib1g-dev_base.init() {
    provision.zlib1g-dev_base.__init() {
        import.useModule 'provision'
    }
    provision.zlib1g-dev_base.require() {

        provision.isInstalled 'zlib1g-dev'
        return $?
    }
}
