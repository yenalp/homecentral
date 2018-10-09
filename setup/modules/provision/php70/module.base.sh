#!/usr/bin/env bash
import.require 'provision'

provision.php70_base.init() {
    provision.php70_base.__init() {
        import.useModule 'provision'
        import.require 'provision.software-properties-common'
    }
    provision.php70_base.require() {
        provision.isInstalled 'php7.0'

        # Add software properties common
        import.useModule 'provision.software-properties-common'
        return $?
    }

    # Install required extensions
    provision.php70_base.requireWithExtensions() {
        provision.php70_base.requireWithExtension "libapache2-mod-php7.0"
        provision.php70_base.requireWithExtension "php7.0-cli"
        provision.php70_base.requireWithExtension "php7.0-dev"
        provision.php70_base.requireWithExtension "php7.0-mysql"
        provision.php70_base.requireWithExtension "php7.0-mbstring"
        provision.php70_base.requireWithExtension "php7.0-json"
        provision.php70_base.requireWithExtension "php7.0-curl"
        provision.php70_base.requireWithExtension "php7.0-gmp"
        provision.php70_base.requireWithExtension "php7.0-mcrypt"
        provision.php70_base.requireWithExtension "php-memcached"
        provision.php70_base.requireWithExtension "php7.0-zip"
        provision.php70_base.requireWithExtension "php-xdebug"
        provision.php70_base.requireWithExtension "php7.0-gd"

    }

    # Install intividual extension
    provision.php70_base.requireWithExtension() {
        provision.isInstalled "${1}"
        return $?
    }

    # Update php ini
    provision.php70_base.updatePhpIni() {
      local __apache_php_ini="/etc/php/7.0/apache2/php.ini"
      local __apache_php_ini_org="/etc/php/7.0/apache2/php.ini.org"

       cp "${__apache_php_ini}" "${__apache_php_ini_org}" || {
        cl "failed to backup the php.ini file ... " -e
      }

      provision.php70_base.updatePhpIniSingle "display_errors" "On"
      provision.php70_base.updatePhpIniSingle "error_reporting" "E_ALL | E_STRICT"
      provision.php70_base.updatePhpIniSingle "html_errors" "On"
      provision.php70_base.updatePhpIniSingle "xdebug.max_nesting_level" "256"
    }

    provision.php70_base.updatePhpIniSingle() {
      local __php_setting="${1}"
      local __php_setting_option="${2}"
      local __apache_php_ini="/etc/php/7.0/apache2/php.ini"
      if  cat /etc/php/7.0/apache2/php.ini | grep -xqFe "${__php_setting} = ${__php_setting_option}"; then
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
