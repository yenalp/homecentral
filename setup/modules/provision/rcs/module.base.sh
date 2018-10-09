#!/usr/bin/env bash
import.require 'provision'

provision.rcs_base.init() {
    provision.rcs_base.__init() {
        import.useModule 'provision'
    }
    provision.rcs_base.require() {
        provision.isInstalled 'rcs'
        return $?
    }
}
