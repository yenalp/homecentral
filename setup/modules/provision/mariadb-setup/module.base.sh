#!/usr/bin/env bash

import.require 'provision'

provision.mariadb-setup_base.init() {
    provision.mariadb-setup_base.__init() {
        import.useModule 'provision'
    }

    # Update config to world
    provision.mariadb-setup_base.updateMariaDbCnf() {
        local __mysqld_config="/etc/mysql/my.cnf"
        local __mysqld_config_org="/etc/mysql/my.cnf.org"

        if [ -f "${__mysqld_config_org}" ]; then
            return 1
        fi
        cp "${__mysqld_config}" "${__mysqld_config_org}"
        cp "${__mysqld_config}" "/root/my.cnf"
        sed -i -e "/^bind-address/s/^#*/#/" "/root/my.cnf"
        sed -i "/bind-address*/abind-address = 0.0.0.0" "/root/my.cnf" || {
            cl "failed to update my.cnf ... " -e
            return 1
        }

        rm "${__mysqld_config}"
        mv "/root/my.cnf" "${__mysqld_config}"

        # Restart the server
        provision.mariadb-setup_base.restart

        return 0
    }

    # Start the mariadb server
    provision.mariadb-setup_base.start() {
        /etc/init.d/mysql restart > /dev/null || {
            cl "failed to start the mariadb server 10.2 ... " -e
            return 1
        }
        return 0
    }

    # Restart the mariadb server
    provision.mariadb-setup_base.restart() {
        /etc/init.d/mysql restart > /dev/null || {
            cl "failed to restart the mariadb server 10.2... " -e
            return 1
        }
        return 0
    }

    # Reload the mariadb server
    provision.mariadb-setup_base.reload() {
        /etc/init.d/mysql restart > /dev/null || {
            cl "failed to reload the mariadb server 10.2 ... " -e
            return 1
        }
        return 0
    }

    # Stop the mariadb server
    provision.mariadb-setup_base.stop() {
        kill `cat /var/run/mysqld/mysqld.pid` || {
            cl "failed to stop the mariadb server 10.2... " -e
            return 1
        }
        return 0
    }


}
