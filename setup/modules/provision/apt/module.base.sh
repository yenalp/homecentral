#!/usr/bin/env bash
import.require 'provision>base'

provision.apt_base.init() {
    provision.apt_base.__init() {
        import.useModule 'provision_base'
    }

    # Force yes and assume yes
    provision.apt_base.forceYes() {
      local __config_file="/etc/apt/apt.conf.d/90forceyes"
      if [ -e  "${__config_file}" ]; then
          cl "force yes has been activated ... " -s
        return 1
      else
          local __block="
APT::Get::Assume-Yes \"true\";
APT::Get::force-yes \"true\";
          "
          echo "${__block}" | tee "${__config_file}" > /dev/null  || {
              cl "activating force yes failed ... " -e
              return 1
          }
          cl "force yes has been activated ... " -s
      fi
      return 0
    }

    # Force  quiet mode
    provision.apt_base.quiet() {
      local __config_file="/etc/apt/apt.conf.d/90quiet"
      if [ -e  "${__config_file}" ]; then
          cl "quiet has been activated ... " -s
        return 1
      else
          local __block="
quiet \"2\";
          "
          echo "${__block}" | tee "${__config_file}" > /dev/null  || {
              cl "activating quiet failed ... " -e
              return 1
          }
          cl "quiet has been activated ... " -s
      fi
      return 0
    }

    # Fix Broken
    provision.apt_base.fixBroken() {
      local __config_file="/etc/apt/apt.conf.d/90fixbroken"
      if [ -e  "${__config_file}" ]; then
          cl "fix broken has been activated ... " -s
        return 1
      else
          local __block="
APT::Get::Fix-Broken \"true\";
          "
          echo "${__block}" | tee "${__config_file}" > /dev/null  || {
              cl "activating fix broken failed ... " -e
              return 1
          }
          cl "fix broken has been activated ... " -s
      fi
      return 0
    }

    # Force confdef
    provision.apt_base.forceConfdef() {
      local __config_file="/etc/apt/apt.conf.d/90forceconfdef"
      if [ -e  "${__config_file}" ]; then
          cl "force confdef has been activated ... " -s
        return 1
      else
          local __block="
Acquire::Check-Valid-Until \"false\";
Dpkg::Options:: \"--force-confdef\";
          "
          echo "${__block}" |  tee "${__config_file}" > /dev/null  || {
              cl "activating force confdef failed ... " -e
              return 1
          }
          cl "force confdef has been activated ... " -s
      fi
      return 0
    }

    # Force confold
    provision.apt_base.forceConfold() {
      local __config_file=" 90forceconfold"
      if [ -e  "${__config_file}" ]; then
          cl "force confold has been activated ... " -s
        return 1
      else
          local __block="
Acquire::Check-Valid-Until \"false\";
Dpkg::Options:: \"--force-confold\";
          "
          echo "${__block}" | tee "${__config_file}" > /dev/null  || {
              cl "activating force confold failed ... " -e
              return 1
          }
          cl "force confold has been activated------ ... " -s
      fi
      return 0
    }
}
