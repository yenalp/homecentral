#!/usr/bin/env bash

import.require 'provision.git>base'

provision.git.init() {
    provision.git.__init() {
        import.useModule "provision.git_base"
        provision.git_base.require "$@"
    }
}
