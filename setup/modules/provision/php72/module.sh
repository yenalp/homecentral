#!/usr/bin/env bash

import.require 'provision.php72>base'

provision.php72.init() {
    provision.php72.__init() {
        import.useModule "provision.php72_base"
        provision.php72_base.addRepository "$@"

        # Need to know if php should be installed as fpm
        if [ -d "/etc/nginx" ]; then
            provision.php72_base.requireFpm "$@"
            provision.php72_base.updatePhpIni "nginx"
            provision.php72_base.restartFpm "$@"
        elif [ -d "/etc/apache2" ]; then
            provision.php72_base.require "$@"
            provision.php72_base.updatePhpIni "apache2"
        fi
        provision.php72_base.requireWithExtensions "$@"
    }
}
