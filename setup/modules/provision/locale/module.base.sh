#!/usr/bin/env bash

import.require 'provision>base'

provision.locale_base.init() {
    provision.locale_base.__init() {
        import.useModule 'provision_base'
    }

    provision.locale_base.update() {
        locale-gen en_US.UTF-8  > /dev/null 2>&1 || {
            cl "failed to update locale to en_US.UTF-8 ... " -e
            return 1
        }
        dpkg-reconfigure locales > /dev/null 2>&1 || {
            cl "failed to update locale to en_US.UTF-8 ... " -e
            return 1
        }
          cl "locale has been updated ..." -s
        return 0
    }

}
