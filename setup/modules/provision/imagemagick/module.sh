#!/usr/bin/env bash

import.require 'provision.imagemagick>base'

provision.imagemagick.init() {
    provision.imagemagick.__init() {
        import.useModule "provision.imagemagick_base"
        provision.imagemagick_base.require "$@"
    }
}
