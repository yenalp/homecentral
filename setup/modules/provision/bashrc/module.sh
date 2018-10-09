#!/usr/bin/env bash

import.require 'provision.bashrc>base'

provision.bashrc.init() {
    provision.bashrc.__init() {
        import.useModule "provision.bashrc_base"
        provision.bashrc_base.prompt "$@"
        provision.bashrc_base.redirect "$@"
        provision.bashrc_base.addVendorPath "$@"
    }
}
