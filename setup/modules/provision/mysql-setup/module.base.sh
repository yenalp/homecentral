#!/usr/bin/env bash

import.require 'provision'

provision.mysql-setup_base.init() {
    provision.mysql-setup_base.__init() {
        import.useModule 'provision'
    }

    # Create databses
    provision.mysql-setup_base.createDb() {
        local __db_name="${1}"
        local __root_password="password"
        local __db_exist=`mysql ${__db_name} -e '' > /dev/null 2>&1;
        echo $?`

        provision.mysql-setup_base.flushPrivileges

        if [ "${__db_exist}" -eq "1" ]; then
            mysql -e "CREATE DATABASE ${__db_name}" || {
            cl "failed to create the mysql \"${__db_name}\"  database ... " -e
            return 1
        }
        fi
        return 0
    }


    # Flushing the privileges
    provision.mysql-setup_base.flushPrivileges() {
        mysql -e "FLUSH PRIVILEGES" || {
            cl "flushing the privileges failed mysql 5.7 server ... " -e
            return 1
        }
        return 0
    }

    # Setting up user
    provision.mysql-setup_base.usersHost() {
        mysql -e "CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY 'password'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION" || {
            cl "failed to create a user ... " -e
            return 1
        }

        # Flush the privileges
        provision.mysql-setup_base.flushPrivileges

        return 0
    }

    # Save password to home directory .my.conf
    provision.mysql-setup_base.myCnf() {
        local __my_cnf="/home/vagrant/.my.cnf"
        local __my_cnf_root="/root/.my.cnf"
        if [ -f "${__my_cnf}" ] && [ -f "${__my_cnf_root}" ] ; then
            return 1
        fi

        local __block="
[client]
user=root
password=password
      "
        echo "${__block}" | tee "${__my_cnf}" "${__my_cnf_root}" > /dev/null || {
            cl "failed to create .my.cnf at \"${__my_cnf}\" ... " -e
        }

        chmod 600 "${__my_cnf}" "${__my_cnf_root}" || {
            cl "failed changing the permissions for .my.cnf at \"${__my_cnf_root}\" ... " -e
        }

        chown vagrant:vagrant "${__my_cnf}" || {
            cl "failed to change .my.cnf to vagrant user at \"${__my_cnf}\" ... " -e
        }

        chown root:root "${__my_cnf_root}" || {
            cl "failed to change .my.cnf to vagrant user at \"${__my_cnf_root}\" ... " -e
        }

    }

}
