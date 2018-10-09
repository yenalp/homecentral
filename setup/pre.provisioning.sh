#!/bin/bash

cl "bootstrapping started ... "

# Don't ask for anything
export DEBIAN_FRONTEND=noninteractive

# Setup progress apt
import.require 'provision.apt'
import.useModule 'provision.apt'

# Setup locale
import.require 'provision.locale'
import.useModule 'provision.locale'

# Adding ssh key
__ssh_dir="/home/vagrant/.ssh"
__id_rsa_key="/home/vagrant/.ssh/vagrant_id_rsa"
__local_id_rsa_key="/vagrant/setup/files/vagrant_id_rsa"

if [ -d "${__ssh_dir}" ];  then
    cl ".ssh directory already exists ... " -s
else
  mkdir "${__ssh_dir}"
  cl ".ssh directoty has been created ... " -s
fi

if [ -f "${__id_rsa_key}" ]; then
    cl "vagrant_id_rsa has already been created ... " -s
else
    cp "${__local_id_rsa_key}" "${__id_rsa_key}"
    cl "vagrant_id_rsa has been created ..." -s
fi

__user=$(stat -c '%U' "${__id_rsa_key}")
__group=$(stat -c '%G' "${__id_rsa_key}")
if [ "${__user}" != "vagrant" ]; then
    chmod -R 600 "${__id_rsa_key}"
    chown -R vagrant:vagrant "${__id_rsa_key}"
    cl "permissions have been updated ... " -s
fi

# Update packages
apt-get update
cl "packages have been updated ... " -s

# Upgrade system
# apt-get -o Dpkg::Options::="--force-confnew" --force-yes -fuy dist-upgrade  > /dev/null 2>&1
apt-get -o Dpkg::Options::="--force-confnew" --allow-downgrades --allow-remove-essential --allow-change-held-packages -fuy dist-upgrade  > /dev/null 2>&1
cl "system is up to date ... " -s
