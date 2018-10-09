#!/usr/bin/env bash
import.require 'provision'

provision.mysql56_base.init() {
    provision.mysql56_base.__init() {
        import.useModule 'provision'
        import.require 'provision.software-properties-common'
    }

    # Add new 5.6 repository
    provision.mysql56_base.addRepository() {
      cl "checking to see if ppa:ondrej/mysql-5.6 has been installed ... "

      grep -h "^deb.*ondrej/mysql-5.6" /etc/apt/sources.list.d/* > /dev/null 2>&1
      if [ $? -ne 0 ]; then
          cl "ppa:ondrej/mysql-5.6 is not installed ... " -f
          cl "attempting to add ppa:ondrej/mysql-5.6 ... "

          # Add software properties common
          import.useModule 'provision.software-properties-common'
          # Install package
           add-apt-repository -y ppa:ondrej/mysql-5.6 > /dev/null 2>&1 || {
            cl "failed to add ppa:ondrej/mysql-5.6 repository ... " -e
            return 1
          }
          cl "ondrej/mysql-5.6 repository has been installed ... " -s

          cl "updating packages ... "
           apt-get update
          cl "packages have been updated ... " -s
      else
          cl "ppa:ondrej/mysql-5.6 is already installed ... "
      fi
      return 0
    }

    # Install mysql server lastest available
    provision.mysql56_base.requireServer() {
        debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
        debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
        provision.isInstalled 'mysql-server-5.6'
        return $?
    }

    # Save password to home directory .my.conf
    provision.mysql56_base.myCnf() {
      local __my_cnf="/home/vagrant/.my.cnf"
      local __my_cnf_root="/root/.my.cnf"
      if [ -f "${__my_cnf}" ]; then
          return 1
      fi

      local __block="
[client]
user=root
password=password
      "

      echo "${__block}" |  tee "${__my_cnf}" "${__my_cnf_root}" > /dev/null || {
        cl "failed to create .my.cnf at \"${__my_cnf}\" ... " -e
      }

       chmod 600 "${__my_cnf}" "${__my_cnf_root}"  || {
        cl "failed changing the permissions for .my.cnf at \"${__my_cnf}\" ... " -e
      }

       chown vagrant:vagrant  "${__my_cnf}" || {
        cl "failed to change .my.cnf to vagrant user at \"${__my_cnf}\" ... " -e
      }
       chown root:root  "${__my_cnf_root}" || {
        cl "failed to change .my.cnf to vagrant user at \"${__my_cnf_root}\" ... " -e
      }
    }

    # Install Mysql Client - laest version available
    provision.mysql56_base.requireClient() {
        provision.isInstalled 'mysql-client-5.6'
        return $?
    }

    # Start the mysql server
    provision.mysql56_base.start() {
           service mysql start || {
              cl "failed to start the mysql 5.6 server ... " -e
              return 1
          }

      return 0
    }

    # Restart the mysql server
    provision.mysql56_base.restart() {
         service mysql restart || {
            cl "failed to restart the mysql 5.6 server ... " -e
            return 1
        }
        return 0
    }

    # Reload the mysql server
    provision.mysql56_base.reload() {
         service mysql reload || {
            cl "failed to reload the mysql 5.6 server ... " -e
            return 1
        }
        return 0
    }

    # Stop the mysql server
    provision.mysql56_base.stop() {
         service mysql stop || {
            cl "failed to stop the mysql 5.6 server ... " -e
            return 1
        }
        return 0
    }

    # Update config to world
    provision.mysql56_base.updateMysqlCnf() {
        local __mysqld_config="/etc/mysql/mysql.conf.d/mysqld.cnf"
        local __mysqld_config_org="/etc/mysql/mysql.conf.d/mysqld.cnf.org"

        if [ -f "${__mysqld_config_org}" ]; then
            return 1
        fi

         cp "${__mysqld_config}" "${__mysqld_config_org}"
         cp "${__mysqld_config}" "/home/${USER}/mysqld.cnf"
         sed -i -e "/^bind-address/s/^#*/#/" "/home/${USER}/mysqld.cnf"
        echo -e  "sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" |  tee -a "/home/${USER}/mysqld.cnf"
         sed -i "/bind-address*/abind-address = 0.0.0.0" "/home/${USER}/mysqld.cnf" || {
            cl "failed to update my.cnf ... " -e
            return 1
        }

         rm "${__mysqld_config}"
         mv "/home/${USER}/mysqld.cnf" "${__mysqld_config}"

        # Restart the server
        provision.mysql56_base.restart

        return 0
    }
}
