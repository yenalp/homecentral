#!/usr/bin/env bash

import.require 'provision.libssl-dev>base'

provision.libssl-dev.init() {
    provision.libssl-dev.__init() {
        import.useModule "provision.libssl-dev_base"
        provision.libssl-dev_base.require "$@"
    }
}
