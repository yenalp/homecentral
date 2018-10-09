#!/usr/bin/env bash

import.require 'provision'

provision.mariadb101_base.init() {
    provision.mariadb101_base.__init() {
        import.useModule 'provision'
        import.require 'provision.software-properties-common'
    }

    # Install mariadb server 10.1 lastest available
    provision.mariadb101_base.requireServer() {
        debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
        debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'

        provision.isInstalled 'mariadb-server'
    }

    # Install mariadb Client - laest version available
    provision.mariadb101_base.requireClient() {
        provision.isInstalled 'mariadb-client'
        return $?
    }

    # Add new php repository
    provision.mariadb101_base.addRepository() {
        local __installed=$(dpkg -l | grep mariadb)
        if [ "${__installed}" != "" ]; then
            return 0
        else
            # Add software properties common
            import.useModule 'provision.software-properties-common'

            apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 > /dev/null 2>&1 || {
            cl "failed to add mariaDB 10.2 server repository ... " -e
            return 1
        }

            # Install package
            add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.aarnet.edu.au/pub/MariaDB/repo/10.1/ubuntu xenial main' > /dev/null 2>&1 || {
            cl "failed to add mariaDB 10.1 server repository ... " -e
            return 1
        }
            apt-get update

        fi
        return 0
    }

}
