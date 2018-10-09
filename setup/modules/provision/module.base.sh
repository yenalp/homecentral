#!/usr/bin/env bash

provision_base.init() {
    provision_base.isInstalled() {
        local __installed=$(dpkg -l | grep "$1")
        if [ "${__installed}" == "" ]; then
            cl "\"${1}\" is not installed ... " -w

            # If Centos/Redhat
            if [ -f /etc/redhat-release ]; then
                provision_base.yum_require $1
            fi

            # Id Ubuntu
            if [ -f /etc/lsb-release ]; then
                provision_base.apt_require $1
            fi
            return 1
        fi

        cl "\"${1}\" is installed ... " -s
        return 0
    }
#    provision_base.require() {
#
#    echo "... ${@} "
#        echo -e "\e[34m\xE2\x84\xB9  INFO: \e[97m  Command \"${1}\" is not dfglkjdflkgjdfkjglkdf"
#        local __item_name="$1"
#        shift;
#        "provision.${__item_name}.require" "$@"
#    }

    provision_base.apt_require()
    {
        apt install $1 > /dev/null 2>&1 || {
          cl "installing \"${1}\" failed ... " -e
          return 1
        }

        cl "installed \"${1}\" ... " -s
        return 0
    }

    provision_base.yum_require() {
        yum install $1 > /dev/null 2>&1 || {
          cl "installing ${1} failed ... " -e
          return 1
        }

        cl "installed ${1} ... " -s
        return 0
    }

    provision_base.isPackageInstalled() {
        if [ $(apt-cache policy "$1" | grep 'Installed: (none)' | wc -l) != '0' ]; then
            echo -e "\e[34m\xE2\x84\xB9  INFO: \e[97m  Package \"${1}\" is not installed"
            return 1
        fi
        return 0
    }
}