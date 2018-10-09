#!/usr/bin/env bash
import.require 'provision'

provision.bashrc_base.init() {
    provision.bashrc_base.__init() {
            import.useModule 'provision'
    }

    provision.bashrc_base.backup() {
      local __bash_rc="/home/vagrant/.bashrc"
      local __bash_rc_org="/home/vagrant/.bashrc.org"

      if [ -f "${__bash_rc_org}" ]; then
          return 1
      else
          cp  "${__bash_rc}" "${__bash_rc_org}" || {
            cl "backing up the .bashrc failed ... " -e
            return 1
          }
      fi
    }

    provision.bashrc_base.prompt() {

      local __bash_rc="/home/vagrant/.bashrc"
      local __block="PS1=\"\[\033[33m\]\u@\H\[\033[1;32m\]:\[\033[34m\] \w\[\033[m\]\[\033[33m\] #>\[\033[37m\] \""

      # Checking bashrc has been backed up
      provision.bashrc_base.backup

      local __installed=$(cat "${__bash_rc}" | grep "PS1=\"\\\\\[\\\\033")
      if [ "${__installed}" != "" ]; then
          return 1
      else
          echo "${__block}" >> "${__bash_rc}" || {
            cl "failed to add the promt to the .bashrc ... " -e
            return 1
          }
          cl "new prompt has been added ..." -s
      fi
      return 0
    }

    provision.bashrc_base.redirect() {
      local __bash_rc="/home/vagrant/.bashrc"
      local __block="cd /vagrant"

      # Checking bashrc has been backed up
      provision.bashrc_base.backup

      if grep -q "${__block}" ${__bash_rc}; then
          return 1
      else
          echo "${__block}" >> "${__bash_rc}" || {
            cl "failed to add the redirect to the .bashrc ... " -e
            return 1
          }
          cl "redirect has been added ..." -s
      fi
    }

    provision.bashrc_base.addVendorPath() {
      local __bash_rc="/home/vagrant/.bashrc"
      local __block="cd /vagrant"
      local __vendor="${BASE_PATH}/vendor/bin"

      if grep -q "vendor" ${__bash_rc}; then
          return 1
      else
          echo "export PATH=\"${__vendor}:\$PATH\"" >> "${__bash_rc}" || {
            cl "failed to add the vendor to the .bashrc ... " -e
            return 1
          }
          cl "vendor path has been added ..." -s
      fi
    }
}
