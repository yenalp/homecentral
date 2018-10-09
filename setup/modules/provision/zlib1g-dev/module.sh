#!/usr/bin/env bash

import.require 'provision.zlib1g-dev>base'

provision.zlib1g-dev.init() {
    provision.zlib1g-dev.__init() {
        import.useModule "provision.zlib1g-dev_base"
        provision.zlib1g-dev_base.require "$@"
    }
}
