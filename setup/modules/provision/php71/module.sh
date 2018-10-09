#!/usr/bin/env bash

import.require 'provision.php71>base'

provision.php71.init() {
    provision.php71.__init() {
        import.useModule "provision.php71_base"
        provision.php71_base.addRepository "$@"

        # Need to know if php should be installed as fpm
        if [ -d "/etc/nginx" ]; then
            provision.php71_base.requireFpm "$@"
            provision.php71_base.updatePhpIni "nginx"
            provision.php71_base.restartFpm "$@"
        elif [ -d "/etc/apache2" ]; then
            provision.php71_base.require "$@"
            provision.php71_base.updatePhpIni "apache2"
        fi
        provision.php71_base.requireWithExtensions "$@"
    }
}
