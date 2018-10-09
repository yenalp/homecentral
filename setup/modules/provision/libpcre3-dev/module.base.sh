#!/usr/bin/env bash
import.require 'provision'

provision.libpcre3-dev_base.init() {
    provision.libpcre3-dev_base.__init() {
        import.useModule 'provision'
    }
    provision.libpcre3-dev_base.require() {
        provision.isInstalled 'libpcre3-dev'
        return $?
    }
}
