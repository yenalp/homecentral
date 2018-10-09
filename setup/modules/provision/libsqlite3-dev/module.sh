#!/usr/bin/env bash

import.require 'provision.libsqlite3-dev>base'

provision.libsqlite3-dev.init() {
    provision.libsqlite3-dev.__init() {
        import.useModule "provision.libsqlite3-dev_base"
        provision.libsqlite3-dev_base.require "$@"
    }
}
