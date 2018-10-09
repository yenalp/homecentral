#!/usr/bin/env bash

import.require 'provision.timezone>base'

provision.timezone.init() {
    provision.timezone.__init() {
        import.useModule "provision.timezone_base"
        provision.timezone_base.update "$@"
    }
}
