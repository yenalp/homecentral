#!/usr/bin/env bash
import.require 'provision'

provision.build-essential_base.init() {
    provision.build-essential_base.__init() {
        import.useModule 'provision'
    }
    provision.build-essential_base.require() {
        provision.isInstalled 'build-essential'
        return $?
    }
}
