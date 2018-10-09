#!/usr/bin/env bash
import.require 'provision'

provision.php71_base.init() {
    provision.php71_base.__init() {
        import.useModule 'provision'
        import.require 'provision.software-properties-common'
    }
    provision.php71_base.require() {
        provision.isInstalled 'php7.1'
        return $?
    }

    provision.php71_base.requireFpm() {
        provision.isInstalled 'php7.1-fpm '
        return $?
    }

    provision.php71_base.restartFpm() {

         systemctl restart php7.1-fpm > /dev/null 2>&1 || {
            cl "restarting php 7.1 fpm failed ... " -e
            return 1
        }

        return 0
    }

    # Add new php repository
    provision.php71_base.addRepository() {
      grep -h "^deb.*ondrej/php" /etc/apt/sources.list.d/* > /dev/null 2>&1
      if [ $? -ne 0 ]; then
          # Add software properties common
          import.useModule 'provision.software-properties-common'

          # Install package
           add-apt-repository -y ppa:ondrej/php > /dev/null 2>&1 || {
            cl "failed to add ppa:ondrej/php repository ... " -e
            return 1
          }
           apt-get update
      fi
      return 0
    }

    # Install required extensions
    provision.php71_base.requireWithExtensions() {
        provision.php71_base.requireWithExtension "libapache2-mod-php7.1"
        provision.php71_base.requireWithExtension "php7.1-cli"
        provision.php71_base.requireWithExtension "php7.1-dev"
        provision.php71_base.requireWithExtension "php7.1-mysql"
        provision.php71_base.requireWithExtension "php7.1-mbstring"
        provision.php71_base.requireWithExtension "php7.1-json"
        provision.php71_base.requireWithExtension "php7.1-curl"
        provision.php71_base.requireWithExtension "php7.1-xml"
        provision.php71_base.requireWithExtension "php7.1-gmp"
        provision.php71_base.requireWithExtension "php7.1-mcrypt"
        provision.php71_base.requireWithExtension "php-memcached"
        provision.php71_base.requireWithExtension "php7.1-zip"
        provision.php71_base.requireWithExtension "php-xdebug"
        provision.php71_base.requireWithExtension "php-imagick"
        provision.php71_base.requireWithExtension "php7.1-gd"
    }

    # Install intividual extension
    provision.php71_base.requireWithExtension() {
        provision.isInstalled "${1}"
        return $?
    }

    # Update php ini
    provision.php71_base.updatePhpIni() {
        local __webserver="${1}"
        if [ "${__webserver}" = "nginx" ]; then
            local __php_ini="/etc/php/7.1/fpm/php.ini"
            local __php_ini_org="/etc/php/7.1/fpm/php.ini.org"
        else
            local __php_ini="/etc/php/7.1/apache2/php.ini"
            local __php_ini_org="/etc/php/7.1/apache2/php.ini.org"
        fi

        cp "${__php_ini}" "${__php_ini_org}" || {
        cl "failed to backup the php.ini file ... " -e
        }

      provision.php71_base.updatePhpIniSingle "display_errors" "On" "${__php_ini}"
      provision.php71_base.updatePhpIniSingle "error_reporting" "E_ALL | E_STRICT" "${__php_ini}"
      provision.php71_base.updatePhpIniSingle "html_errors" "On" "${__php_ini}"
      provision.php71_base.updatePhpIniSingle "xdebug.max_nesting_level" "256" "${__php_ini}"
    }

    provision.php71_base.updatePhpIniSingle() {
      local __php_setting="${1}"
      local __php_setting_option="${2}"
      local __apache_php_ini="${3}"
      if  cat "${__apache_php_ini}" | grep -xqFe "${__php_setting} = ${__php_setting_option}"; then
        return 1
      else
        if grep -q "\"${__php_setting}\"" ${__apache_php_ini}; then
             sed -i "s/${__php_setting} = .*/${__php_setting} = ${__php_setting_option}/" ${__apache_php_ini} || {
                cl "failed to update ${__php_setting} option in the php.ini config ... " -e
                return 1
            }
        else
            echo -e  "${__php_setting} = ${__php_setting_option}" |  tee -a "${__apache_php_ini}" > /dev/null 2>@1 || {
                cl "failed to update ${__php_setting} option in the php.ini config ... " -e
                return 1
            }
        fi
      fi
      return 0
    }
}
