#!/usr/bin/env bash

import.require 'provision.nfs-common>base'

provision.nfs-common.init() {
    provision.nfs-common.__init() {
        import.useModule "provision.nfs-common_base"
        provision.nfs-common_base.require "$@"
    }
}
