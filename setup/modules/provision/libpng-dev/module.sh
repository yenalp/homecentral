#!/usr/bin/env bash

import.require 'provision.libpng-dev>base'

provision.libpng-dev.init() {
    provision.libpng-dev.__init() {
        import.useModule "provision.libpng-dev_base"
        provision.libpng-dev_base.require "$@"
    }
}
