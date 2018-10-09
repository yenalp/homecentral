#!/usr/bin/env bash

import.require 'provision.libpcre3-dev>base'

provision.libpcre3-dev.init() {
    provision.libpcre3-dev.__init() {
        import.useModule "provision.libpcre3-dev_base"
        provision.libpcre3-dev_base.require "$@"
    }
}
