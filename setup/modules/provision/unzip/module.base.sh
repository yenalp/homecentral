#!/usr/bin/env bash2>&1
import.require 'provision'

provision.unzip_base.init() {
    provision.unzip_base.__init() {
        import.useModule 'provision'
    }

    provision.unzip_base.require() {
        provision.isInstalled 'unzip'
        return $?
    }
}
