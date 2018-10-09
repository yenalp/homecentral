#!/usr/bin/env bash
import.require 'provision'

provision.apache_base.init() {
    provision.apache_base.__init() {
        import.useModule 'provision'
    }

    # Install Apache Server
    provision.apache_base.require() {
        provision.isInstalled 'apache2'
        return $?
    }

    # Start the apache server
    provision.apache_base.start() {

        service apache2 start || {
          cl "failed to start the apache server ... " -e
          return 1
        }
        return 0
    }

    # Restart the apache server
    provision.apache_base.restart() {
         service apache2 restart || {
          cl "failed to restart the apache server ... " -e
          return 1
        }
        return 0
    }

    # Reload the apache server
    provision.apache_base.reload() {
         service apache2 reload || {
          cl "failed to reload the apache server ... " -e
          return 1
        }
        return 0
    }

    # Disable all enabled sites
    provision.apache_base.diableAllEnabledSites() {
        local __conf_en_sites='/etc/apache2/sites-enabled'

        if [ ! -d "${__conf_en_sites}" ]; then
            cl "could not find \"${__conf_en_sites}\" directory ... " -e
        else
             find "${__conf_en_sites}" -maxdepth 1 -type l -exec rm -f {} \;
        fi
        return "$?"
    }

    # Enable new site config
    provision.apache_base.enabledSite() {
         a2ensite default.conf > /dev/null || {
          cl "enabling site default.conf failed ... " -e
          return 1
        }
        return 0
    }

    # Create a new vhost file
    provision.apache_base.createVhostConfig() {
        local __config_file="/etc/apache2/sites-available/default.conf"
        if [ -e  "${__config_file}" ]; then
          # Do nothing
          return 1
        fi

        local __block="
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    <Directory \"/var/www/html\">
        AllowOverride All
    </Directory>
</VirtualHost>

<IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
        <Directory \"/var/www/html\">
            AllowOverride All
        </Directory>

        SSLEngine on
        SSLCertificateFile  /etc/apache2/ssl/cert.pem
        SSLCertificateKeyFile /etc/apache2/ssl/privkey.pem
    </VirtualHost>
</IfModule>
        "
        echo "${__block}" |  tee "${__config_file}" > /dev/null || {
          cl "creating site config at \"${__config_file}\" failed ... " -e
        }

        # disable all sites enables
        provision.apache_base.diableAllEnabledSites

        # Enable default.conf
        provision.apache_base.enabledSite

        # Reload the apache config
        provision.apache_base.reload

        return 0

    }

    # Enable modules
    provision.apache_base.enableModules() {
        provision.apache_base.enableModule "rewrite"
        provision.apache_base.enableModule "ssl"
        provision.apache_base.enableModule "headers"
        return 0
    }

    # Enable individual module
    provision.apache_base.enableModule() {
        local __module="$1"
         a2enmod "${__module}"  > /dev/null || {
          cl "failed to enable \"${__module}\" module ... "
          return 1
        }
        return 0
    }

    provision.apache_base.configureSSL() {
        return 0
    }
}
