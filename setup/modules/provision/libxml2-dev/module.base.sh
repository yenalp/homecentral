#!/usr/bin/env bash
import.require 'provision'

provision.libxml2-dev_base.init() {
    provision.libxml2-dev_base.__init() {
        import.useModule 'provision'
    }
    provision.libxml2-dev_base.require() {
        provision.isInstalled 'libxml2-dev'
        return $?
    }
}
