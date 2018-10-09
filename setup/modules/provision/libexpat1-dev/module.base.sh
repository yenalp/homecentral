#!/usr/bin/env bash
import.require 'provision'

provision.libexpat1-dev_base.init() {
    provision.libexpat1-dev_base.__init() {
        import.useModule 'provision'
    }
    provision.libexpat1-dev_base.require() {
        provision.isInstalled 'libexpat1-dev'
        return $?

#      local __installed=$(dpkg -l | grep -w "^\(ii  libexpat1-dev\)" | grep -v man)
#      cl  "checking to see if libexpat1-dev is installed ... "
#      if [ "${__installed}" != "" ]; then
#          cl "libexpat1-dev is already installed ... " -w
#          return 0
#      else
#          cl "libexpat1-dev is not installed ... " -f
#          cl "attempting to install libexpat1-dev ... "
#          sudo apt-get install libexpat1-dev > /dev/null 2>&1 || {
#              cl "installing libexpat1-dev failed ... " -e
#              return 1
#          }
#          cl "libexpat1-dev has been installed ... " -s
#      fi
#      return 0
    }
}
