#!/usr/bin/env bash

import.require 'provision'

provision.composer_base.init() {
    provision.composer_base.__init() {
        import.useModule 'provision'
    }

    provision.composer_base.install() {
        if [ ! -f "/usr/local/bin/composer" ]; then
            __composer_install_path="/tmp/composer-setup.php"
            curl -sS https://getcomposer.org/installer >"$__composer_install_path" || {
            cl "failed to download the composer installer ... " -e
            return 1
        }

            php "$__composer_install_path" --install-dir=/usr/local/bin --filename=composer || {
            cl "failed to run the composer installer ... " -e
            return 1
        }

            rm "$__composer_install_path"
        else
            cl "composer is installed ... " -s
            return 0
        fi
        return 0
    }

}
