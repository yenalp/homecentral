#!/usr/bin/env bash
import.require 'provision'

provision.libsqlite3-dev_base.init() {
    provision.libsqlite3-dev_base.__init() {
        import.useModule 'provision'
    }
    provision.libsqlite3-dev_base.require() {
        provision.isInstalled 'libsqlite3-dev'
        return $?
    }
}
