#!/usr/bin/env bash

import.require 'provision.mount-folder>base'

provision.mount-folder.init() {
    provision.mount-folder.__init() {
        import.useModule "provision.mount-folder_base"
        provision.mount-folder_base.makeProjectData "$@"
        provision.mount-folder_base.mountBubbles "$@"
        provision.mount-folder_base.createProjectFolder "$@"
    }
}
