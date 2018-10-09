#!/usr/bin/env bash

import.require 'provision.apt>base'
provision.apt.init() {
    provision.apt.__init() {
        import.useModule "provision.apt_base"
        provision.apt_base.forceYes "$@"
        provision.apt_base.quiet "$@"
        provision.apt_base.fixBroken "$@"
        provision.apt_base.forceConfdef "$@"
    }
}
