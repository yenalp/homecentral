#!/usr/bin/env bash

import.require 'provision'

provision.postfix_base.init() {
    provision.postfix_base.__init() {
        import.useModule 'provision'
    }

    # Install required packasges
    provision.postfix_base.require() {
         debconf-set-selections <<<"postfix postfix/mailname string localhost"
         debconf-set-selections <<<"postfix postfix/main_mailer_type string 'Internet Site'"

        provision.isInstalled 'postfix'
        return $?
    }

    # Restart the postfix server
    provision.postfix_base.restart() {
         service postfix restart || {
            cl "failed to restart the postfix server ... " -e
            return 1
        }
        return 0
    }

    # Modify to core config
    provision.postfix_base.configSetup() {
        local __main_cf="/etc/postfix/main.cf"
        if grep -h "devrelay.in.monkii.com" "${__main_cf}" > /dev/null 2> @1; then
            return 1
        else
             sed -i '/relayhost =/c relayhost = \[devrelay.in.monkii.com\]' "${__main_cf}" > /dev/null 2> @1 || {
            return 1
        }

            # Restart postfix server
            provision.postfix_base.restart

        fi
        return 0
    }

}
