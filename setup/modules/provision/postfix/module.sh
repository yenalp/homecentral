#!/usr/bin/env bash

import.require 'provision.postfix>base'

provision.postfix.init() {
    provision.postfix.__init() {
        import.useModule "provision.postfix_base"
        provision.postfix_base.require "$@"
        provision.postfix_base.configSetup "$@"
    }
}
