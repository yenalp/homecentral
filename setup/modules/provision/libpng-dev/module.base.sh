#!/usr/bin/env bash
import.require 'provision'

provision.libpng-dev_base.init() {
    provision.libpng-dev_base.__init() {
        import.useModule 'provision'
    }
    provision.libpng-dev_base.require() {
        provision.isInstalled 'libpng-dev'
        return $?
    }
}
