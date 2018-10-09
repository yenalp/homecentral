#!/usr/bin/env bash

import.require 'provision.libxml2-dev>base'

provision.libxml2-dev.init() {
    provision.libxml2-dev.__init() {
        import.useModule "provision.libxml2-dev_base"
        provision.libxml2-dev_base.require "$@"
    }
}
