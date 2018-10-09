#!/usr/bin/env bash

import.require 'provision.ssl>base'

provision.ssl.init() {
    provision.ssl.__init() {
        import.useModule "provision.ssl_base"
        provision.ssl_base.generateSSL "$@"
        provision.ssl_base.addCertsLocally "$@"
    }
}
