#!/usr/bin/env bash

import.require 'provision'

provision.mysql57_base.init() {
    provision.mysql57_base.__init() {
        import.useModule 'provision'
    }

    # Install mysql server lastest available
    provision.mysql57_base.requireServer() {
         debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
         debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'

        provision.isInstalled 'mysql-server'
        return $?

    }

    # Install Mysql Client - laest version available
    provision.mysql57_base.requireClient() {
        provision.isInstalled 'mysql-client'
        return $?
    }

    # Start the mysql server
    provision.mysql57_base.start() {
        service mysql start || {
            cl "failed to start the mysql 5.7 server ... " -e
            return 1
        }
        return 0
    }

    # Restart the mysql server
    provision.mysql57_base.restart() {

        service mysql restart || {
            cl "failed to restart the mysql 5.7 server ... " -e
            return 1
        }

        return 0
    }

    # Reload the mysql server
    provision.mysql57_base.reload() {

        service mysql reload || {
            cl "failed to reload the mysql 5.7 server ... " -e
            return 1
        }

        return 0
    }

    # Stop the mysql server
    provision.mysql57_base.stop() {

        service mysql stop || {
            cl "failed to stop the mysql 5.7 server ... " -e
            return 1
        }

        return 0
    }

    # Update config to world
    provision.mysql57_base.updateMysqlCnf() {
        local __mysqld_config="/etc/mysql/mysql.conf.d/mysqld.cnf"
        local __mysqld_config_org="/etc/mysql/mysql.conf.d/mysqld.cnf.org"

        if [ -f "${__mysqld_config_org}" ]; then
            return 1
        fi

        cp "${__mysqld_config}" "${__mysqld_config_org}"
        cp "${__mysqld_config}" "/home/${USER}/mysqld.cnf"
        sed -i -e "/^bind-address/s/^#*/#/" "/home/${USER}/mysqld.cnf"

        echo -e "sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" | tee -a "/home/${USER}/mysqld.cnf"

        sed -i "/bind-address*/abind-address = 0.0.0.0" "/home/${USER}/mysqld.cnf" || {
            cl "failed to update my.cnf ... " -e
            return 1
        }

        rm "${__mysqld_config}"
        mv "/home/${USER}/mysqld.cnf" "${__mysqld_config}"

        # Restart the server
        provision.mysql57_base.restart

        return 0
    }

}
