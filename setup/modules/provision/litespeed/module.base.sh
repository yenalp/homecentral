#!/usr/bin/env bash
import.require 'provision'

provision.litespeed_base.init() {
    provision.litespeed_base.__init() {
        import.useModule 'provision'
        import.require 'provision.build-essential'
        import.require 'provision.libexpat1-dev'
        import.require 'provision.libgeoip-dev'
        import.require 'provision.libpcre3-dev'
        import.require 'provision.zlib1g-dev'
        import.require 'provision.libssl-dev'
        import.require 'provision.libxml2-dev'
        import.require 'provision.rcs'
        import.require 'provision.libpng-dev'
    }

    # Install litespeed Server
    provision.litespeed_base.require() {

          # import required modules
          import.useModule 'provision.build-essential'
          import.useModule 'provision.libexpat1-dev'
          import.useModule 'provision.libgeoip-dev'
          import.useModule 'provision.libpcre3-dev'
          import.useModule 'provision.zlib1g-dev'
          import.useModule 'provision.libssl-dev'
          import.useModule 'provision.libxml2-dev'
          import.useModule 'provision.rcs'
          import.useModule 'provision.libpng-dev'

          # Download package
          provision.litespeed_base.download

          provision.isInstalled 'litespeed'
          return $?


      return 0
    }

    provision.litespeed_base.download() {
        cd ~
        if [ -f "/home/vagrant/openlitespeed-1.4.27.tgz" ]; then
            return 1
        else
            cl "attempting to download litseed ... "
                wget http://open.litespeedtech.com/packages/openlitespeed-1.4.27.tgz  > /dev/null  2>&1 || {
                cl "failed to download litespeed ... " -e
                return 1
            }
        fi
        return 0
    }

    # Start the litespeed server
    provision.litespeed_base.start() {
         systemctl reload-or-restart litespeed || {
          cl "failed to start the litespeed server ... " -e
          return 1
        }
        return 0
    }

    # Restart the litespeed server
    provision.litespeed_base.restart() {
         systemctl reload-or-restart litespeed|| {
          cl "failed to restart the litespeed server ... " -e
          return 1
        }
        return 0
    }

    # Reload the litespeed server
    provision.litespeed_base.reload() {
         systemctl reload-or-restart litespeed || {
          cl "failed to reload the litespeed server ... " -e
          return 1
        }
        return 0
    }

    # Disable all enabled sites
    provision.litespeed_base.diableAllEnabledSites() {
        local __conf_en_sites='/etc/litespeed/sites-enabled'
        if [ ! -d "${__conf_en_sites}" ]; then
            return "$?"
        else
             find "${__conf_en_sites}" -maxdepth 1 -type l -exec rm -f {} \;
        fi
        return "$?"
    }

    # Enable new site config
    provision.litespeed_base.enabledSite() {
         ln -s /etc/litespeed/sites-available/default /etc/litespeed/sites-enable/default > /dev/null || {
          cl "enabling site default failed ... " -e
          return 1
        }
        return 0
    }

    # Create a new vhost file
    provision.litespeed_base.createSiteConfig() {
        local __config_file="/etc/litespeed2/sites-available/default"
        local __config_file_org="/etc/litespeed2/sites-available/default.org"
        if [ -e  "${__config_file_org}" ]; then
          return 1
        fi

        local __block="
server {
    listen 80 default_server;
    listen [::]:80 default_server;;
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;

    server_name www;
    root /var/www/html

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/litespeed/error.log error;

    sendfile off;

    client_max_body_size 100m;

    location ~ /\.ht {
        deny all;
    }

    ssl_certificate     /etc/litespeed/ssl/cert.pem
    ssl_certificate_key /etc/litespeed/ssl/privkey.pem
}
        "
         cp "${__config_file}" "${__config_file_org}" || {
            cl "failed to backup orignal config ..." -e
        }

        echo "${__block}" |  tee "${__config_file}" > /dev/null || {
          cl "creating site config at \"${__config_file}\" failed ... " -e
        }

        # disable all sites enables
        provision.litespeed_base.diableAllEnabledSites

        # Enable default.conf
        provision.litespeed_base.enabledSite

        # Reload the litespeed config
        provision.litespeed_base.reload

        return 0

    }

    # Enable modules
    provision.litespeed_base.enableModules() {
        provision.litespeed_base.enableModule "rewrite"
        provision.litespeed_base.enableModule "ssl"
        provision.litespeed_base.enableModule "headers"
        return 0
    }

    # Enable individual module
    provision.litespeed_base.enableModule() {
        local __module="$1"
         a2enmod "${__module}"  > /dev/null || {
          cl "failed to enable \"${__module}\" module ... "
          return 1
        }
        cl "\"${__module}\" module has been enabled ..." -s
        return 0
    }

    provision.litespeed_base.configureSSL() {
        return 0
    }
}
