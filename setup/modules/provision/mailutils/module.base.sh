#!/usr/bin/env bash

import.require 'provision'

provision.mailutils_base.init() {
    provision.mailutils_base.__init() {
        import.useModule 'provision'
    }

    provision.mailutils_base.require() {
        provision.isInstalled 'mailutils'
        return $?
    }

}
