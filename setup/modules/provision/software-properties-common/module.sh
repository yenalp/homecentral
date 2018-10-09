#!/usr/bin/env bash

import.require 'provision.software-properties-common>base'

provision.software-properties-common.init() {
    provision.software-properties-common.__init() {
        import.useModule "provision.software-properties-common_base"
        provision.software-properties-common_base.require "$@"
    }
}
