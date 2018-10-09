#!/usr/bin/env bash
import.require 'provision'

provision.timezone_base.init() {
    provision.timezone_base.__init() {
        import.useModule 'provision'
    }
    provision.timezone_base.update() {
      local __timezone_conf="/etc/timezone"
      local __timezone_conf_org="/etc/timezone.org"

      if grep -h "^Australia/Melbourne" "${__timezone_conf}" > /dev/null 2>&1; then
        cl "timezone has already been set ... " -w
        return 1
      else
        cp "${__timezone_conf}" "${__timezone_conf_org}" || {
          cl "failed to backup timezone ... " -e
          return 1
        }

        echo "Australia/Melbourne" | tee "${__timezone_conf}" > /dev/null  || {
            cl "failed to update the timezone to Australia/Melbourne ... " -e
            return 1
        }

        dpkg-reconfigure --frontend noninteractive tzdata  > /dev/null 2>&1 || {
            cl "failed to reconfigure tzdata ... " -e
            return 1
        }
        cl "tzdata reconfigured ... " -s
      fi
      return 0
    }
}
