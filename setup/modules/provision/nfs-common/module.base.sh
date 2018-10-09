#!/usr/bin/env bash
import.require 'provision'

provision.nfs-common_base.init() {
    provision.nfs-common_base.__init() {
        import.useModule 'provision'
    }
    provision.nfs-common_base.require() {
        provision.isInstalled 'nfs-common'
        return $?
    }
}
