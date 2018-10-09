#!/usr/bin/env bash

import.require 'provision>base'

provision.init() {
    provision.__init() {
        import.useModule 'provision_base'
    }

    provision.isInstalled() {
        provision_base.isInstalled "$@"
    }

    provision.isPackageInstalled() {
        provision_base.isPackageInstalled "$@"
    }

    provision.require() {
        provision_base.require "$@"
    }

}
