#!/usr/bin/env bash

import.require 'provision.mailutils>base'

provision.mailutils.init() {
    provision.mailutils.__init() {
        import.useModule "provision.mailutils_base"
        provision.mailutils_base.require "$@"
    }
}
