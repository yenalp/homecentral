#!/usr/bin/env bash

import.require 'provision'

provision.git_base.init() {
    provision.git_base.__init() {
        import.useModule 'provision'
    }

    provision.git_base.require() {
        provision.isInstalled 'git'
        return $?
    }

}
