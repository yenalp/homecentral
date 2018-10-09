#!/usr/bin/env bash

import.require 'provision.build-essential>base'

provision.build-essential.init() {
    provision.build-essential.__init() {
        import.useModule "provision.build-essential_base"
        provision.build-essential_base.require "$@"
    }
}
