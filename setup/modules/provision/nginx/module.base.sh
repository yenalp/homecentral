#!/usr/bin/env bash
import.require 'provision'

provision.nginx_base.init() {
    provision.nginx_base.__init() {
        import.useModule 'provision'
        import.require 'provision.apache'
    }

    # Install nginx Server
    provision.nginx_base.require() {
        provision.isInstalled 'nginx'
        return $?
    }

    # Start the nginx server
    provision.nginx_base.start() {
         service nginx restart || {
          cl "failed to start the nginx server ... " -e
          return 1
        }
        return 0
    }

    # Restart the nginx server
    provision.nginx_base.restart() {
        service nginx restart|| {
          cl "failed to restart the nginx server ... " -e
          return 1
        }
        return 0
    }

    # Reload the nginx server
    provision.nginx_base.reload() {
       service nginx restart  || {
          cl "failed to reload the nginx server ... " -e
          return 1
        }
        return 0
    }

    # Disable all enabled sites
    provision.nginx_base.diableAllEnabledSites() {
        local __conf_en_sites='/etc/nginx/sites-enabled'
        if [ -d "${__conf_en_sites}" ]; then
             find "${__conf_en_sites}" -maxdepth 1 -type l -exec rm -f {} \;
            cl "all existing enabled sites have been disabled ... " -s
        fi
        return "$?"
    }

    # Enable new site config
    provision.nginx_base.enabledSite() {
         ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default > /dev/null || {
          cl "enabling site default failed ... " -e
          return 1
        }
        return 0
    }

    # Create a new vhost file
    provision.nginx_base.createSiteConfig() {
        local __config_file="/etc/nginx/sites-available/default"
        local __config_file_org="/etc/nginx/sites-available/default.org"
        if [ -e  "${__config_file_org}" ]; then
          # Do Nothing
          return 1
        fi

        local __block="
server {
    listen 80 default_server;
    listen 443 ssl default_server;

    server_name www;
    root /var/www/html;

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log  /var/log/nginx/error.log error;

    sendfile off;

    client_max_body_size 100m;

    location ~ /\.ht {
        deny all;
    }

    ssl_certificate     /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;
}
        "
         cp "${__config_file}" "${__config_file_org}" || {
            cl "failed to backup orignal config ..." -e
        }

        echo "${__block}" |  tee "${__config_file}" > /dev/null || {
          cl "creating site config at \"${__config_file}\" failed ... " -e
        }

        # disable all sites enables
        provision.nginx_base.diableAllEnabledSites

        # Enable default.conf
        provision.nginx_base.enabledSite

        # Reload the nginx config
        provision.nginx_base.reload

        return 0

    }
}
