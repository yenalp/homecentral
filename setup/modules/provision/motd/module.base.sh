#!/usr/bin/env bash
import.require 'provision'

MOTD_USER='vagrant'

provision.motd_base.init() {
    provision.motd_base.__init() {
        import.useModule 'provision'
    }

    provision.motd_base.require() {
        provision.isInstalled 'update-motd'
        return $?
    }

    provision.motd_base.createMotd() {
        local __block="#!/bin/sh

printf \"Project URLS\"
printf \"\\n\\n\"
printf \"   * HTTP\\n\"
printf \"       * URL: http://XX.in.monkii.com:\\n\"
printf \"   * HTTPS\\n\"
printf \"       * URL: http://XX.in.monkii.com:\\n\""
        echo -e "${__block}"
    }

    provision.motd_base.add() {
        local __moto_base="/etc/update-motd.d/00-header"

        provision.motd_base.backup "00-header"
        provision.motd_base.backup "10-help-text"
        provision.motd_base.backup "90-updates-available"
        provision.motd_base.backup "91-release-upgrade"
        provision.motd_base.backup "97-overlayroot"
        provision.motd_base.backup "98-fsck-at-reboot"
        provision.motd_base.backup "98-reboot-required"

        provision.motd_base.turnOff "00-header.org"
        provision.motd_base.turnOff "10-help-text.org"
        provision.motd_base.turnOff "10-help-text"
        provision.motd_base.turnOff "90-updates-available.org"
        provision.motd_base.turnOff "91-release-upgrade.org"
        provision.motd_base.turnOff "97-overlayroot.org"
        provision.motd_base.turnOff "98-fsck-at-reboot.org"
        provision.motd_base.turnOff "98-reboot-required.org"

         cat /dev/null > "/home/${MOTD_USER}/00-header"
        provision.motd_base.createMotd |  tee -a "/home/${MOTD_USER}/00-header" > /dev/null || {
            cl "failed to create custom motd ... " -e
            return 1
        }

         mv "/home/${MOTD_USER}/00-header" /etc/update-motd.d/00-header || {
            cl "failed to install custom motd ..." -e
            return 1
        }
         chmod 755 /etc/update-motd.d/00-header
         chown root:root /etc/update-motd.d/00-header
        cl "custom motd installed ... " -s
        return 0

    }

    # backup motod
    provision.motd_base.backup() {
        local __file_name="${1}"
        local __file_path="/etc/update-motd.d/${1}"

         cp "${__file_path}" "${__file_path}.org" > /dev/null 2>&1|| {
            cl "failed to backup ${__file_name} ... " -e
            return 1
        }

        return 0
    }

    # backup motod
    provision.motd_base.turnOff() {
        local __file_name="${1}"
        local __file_path="/etc/update-motd.d/${1}"
         chmod -x ${__file_path} > /dev/null 2>&1 || {
            return 1
        }
        return 0
    }

}
