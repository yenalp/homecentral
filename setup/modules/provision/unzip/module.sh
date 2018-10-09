#!/usr/bin/env bash

import.require 'provision.unzip>base'
provision.unzip.init() {
    provision.unzip.__init() {
        import.useModule "provision.unzip_base"
        provision.unzip_base.require "$@"
    }
}
