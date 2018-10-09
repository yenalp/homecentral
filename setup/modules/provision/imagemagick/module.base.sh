#!/usr/bin/env bash
import.require 'provision'

provision.imagemagick_base.init() {
    provision.imagemagick_base.__init() {
        import.useModule 'provision'
    }
    provision.imagemagick_base.require() {
        provision.isInstalled 'imagemagick'
        return $?
    }
}
