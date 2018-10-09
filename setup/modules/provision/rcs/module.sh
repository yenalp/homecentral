#!/usr/bin/env bash

import.require 'provision.rcs>base'

provision.rcs.init() {
    provision.rcs.__init() {
        import.useModule "provision.rcs_base"
        provision.rcs_base.require "$@"
    }
}
