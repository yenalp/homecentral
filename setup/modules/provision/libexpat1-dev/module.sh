#!/usr/bin/env bash

import.require 'provision.libexpat1-dev>base'

provision.libexpat1-dev.init() {
    provision.libexpat1-dev.__init() {
        import.useModule "provision.libexpat1-dev_base"
        provision.libexpat1-dev_base.require "$@"
    }
}
