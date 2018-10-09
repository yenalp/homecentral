#!/usr/bin/env bash

import.require 'provision.locale>base'
provision.locale.init() {
    provision.locale.__init() {
        import.useModule "provision.locale_base"
        provision.locale_base.update "$@"
    }
}
