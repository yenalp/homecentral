#!/usr/bin/env bash
import.require 'provision'
import.require 'provision.apache'
import.require 'provision.nginx'

provision.ssl_base.init() {
    provision.ssl_base.__init() {
        import.useModule 'provision'
        import.useModule "provision.apache_base"
        import.useModule "provision.nginx_base"
    }

    provision.ssl_base.generateSSL() {
        if [ -d "/etc/apache2" ]; then
            local __ssl_dir="/etc/apache2/ssl"
            local __ssl_cert="/etc/apache2/ssl/cert.pem"
            provision.ssl_base.makeSSLDirectory "${__ssl_dir}"
            provision.ssl_base.getCerts "${__ssl_dir}" "${__ssl_cert}"
            provision.apache_base.restart
        fi
        if [ -d "/etc/nginx" ]; then
            local __ssl_dir="/etc/nginx/ssl"
            local __ssl_cert="/etc/nginx/ssl/cert.pem"
            provision.ssl_base.makeSSLDirectory "${__ssl_dir}"
            provision.ssl_base.getCerts "${__ssl_dir}" "${__ssl_cert}"
            provision.nginx_base.restart
            provision.apache_base.stop
        fi
    }

    provision.ssl_base.makeSSLDirectory() {
        local __ssl_dir="${1}"
        if [ -d "$__ssl_dir" ]; then
            return 0
        else
             mkdir -p "${__ssl_dir}" > /dev/null 2>&1 || {
                cl "failed to create the ssl directory ... " -e
                return 1
            }
        fi
        return 0
    }

    provision.ssl_base.getCerts() {

        local __ssl_cert_dir="${1}"
        local __ssl_cert="${2}"
          if [ -f "${__ssl_cert}" ]; then
              return 0
          else
               scp -i /home/vagrant/.ssh/vagrant_id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no monkii@gordo:"./in.monkii.com-ssl/*" "${__ssl_cert_dir}" || {
                  cl "failed to get the ssl certs ... " -e
                  return 1
              }
          fi
          return 0
    }

    provision.ssl_base.addCertsLocally() {

        local __ssl_cert_dir="/etc/apache2/ssl"
        local __vagrant_setup="/vagrant/setup"

        if [ -d "${__ssl_cert_dir}" ]; then
            cp -r "${__ssl_cert_dir}" "${__vagrant_setup}" || {
                  cl "failed to cop the certs locally ... " -e
                  return 1
            }
        fi
        return 0
    }
}
