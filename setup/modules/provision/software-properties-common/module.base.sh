#!/usr/bin/env bash
import.require 'provision'

provision.software-properties-common_base.init() {
    provision.software-properties-common_base.__init() {
        import.useModule 'provision'
    }

    # Install required packages
    provision.software-properties-common_base.require() {
        provision.isInstalled 'software-properties-common'
        return $?
    }
}
