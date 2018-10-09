#!/usr/bin/env bash

import.require 'provision>base'

provision.postgres10_base.init() {
    provision.postgres10_base.__init() {
        cl "====== postgres ====== "
        import.useModule 'provision_base'
        import.require 'provision.software-properties-common'
    }

    # Install mysql server lastest available
    provision.postgres10_base.requireServer() {
      cl "checking to see if postgres server 10 has been installed ... "

      local __installed=$(dpkg -l | grep postgresql-10)
      if [ "${__installed}" != "" ]; then
          cl "postgres server 10 already installed ... " -w
          return 0
      else
        cl "postgres server 10 is not installed ... " -f
        cl "attempting to installing postgres server 10 ... "
        sudo apt-get install postgresql postgresql-contrib > /dev/null 2>&1 || {
          cl "failed to install postgres server 10 ... " -e
          return 1
        }
        cl "postgres server 10 has been installed ... " -s

      fi
      return 0
    }

    # Add new repository
    provision.postgres10_base.addRepository() {
      cl "checking to see if postgres server 10  repository has been installed ... "

      local __installed=$(dpkg -l | grep postgresql-10)
      if [ "${__installed}" != "" ]; then
          cl "postgres server 10  is already installed ... " -w
      else
          cl "postgres server 10  not installed ... " -f

          # Add software properties common
          import.useModule 'provision.software-properties-common'

          # Install keys
          cl "attempting to install new keys ... "
          wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add - > /dev/null 2>&1 || {
              cl "failed to install new keys ... " -e
          }
          cl "new keys have been installed ... " -s

          cl "attempting to add postgres server 10  ... "
          # Install package
          sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' > /dev/null 2>&1 || {
            cl "failed to add postgres server 10  repository ... " -e
            return 1
          }
          cl "postgres server 10  repository has been added ... " -s


          cl "updating packages ... "
          sudo apt-get update
          cl "packages have been updated ... " -s
      fi
      return 0
    }





    provision.postgres10_base.userExists() {
        local __userExists=''
        cl "checking to see if postgres user exists ... "
        __userExists=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='root'")
        if [ "${__userExists}" == '1' ]; then
            cl "posgress user has already been added ... " -w
            return 0
        fi
        cl "posgres user does not exist ... " -f
        return 1
    }

    # Save password to home directory .my.conf
    provision.postgres10_base.addUser() {
        if ! provision.postgres10_base.userExists; then
            cl "attempting to add the postgres user ... "
            sudo -u postgres \
                psql -c "CREATE USER root WITH PASSWORD 'password';" || {
                cl "Could not create postgres db user root ... " -e
                return 1
            }

            cl "postgres user has been added ... " -s

        fi
    }

    # Start the mysql server
    provision.postgres10_base.start() {
        cl "checking postgres server 10 is running ... "
        if sudo ps ax | grep -v grep | grep postgresqld > /dev/null
        then
            cl "postgres server 10 is already running ... " -w
        else
            sudo service postgresql start || {
                cl "failed to start the postgres server 10 ... " -e
                return 1
            }
            cl "postgres server 10 has started ... " -s
        fi
        return 0
    }

    # Restart the mysql server
    provision.postgres10_base.restart() {
        cl "restarting the postgres server 10 ... "
        sudo service postgresql restart || {
            cl "failed to restart the postgres server 10 ... " -e
            return 1
        }
        cl "postgres server 10 has been restarted ... " -s
        return 0
    }

    # Reload the mysql server
    provision.postgres10_base.reload() {
        cl "reloading mysql server ... "
        sudo service postgresql reload || {
            cl "failed to reload the postgres server 10 ... " -e
            return 1
        }
        cl "postgres server 10 has been reloaded ... " -s
        return 0
    }

    # Stop the mysql server
    provision.postgres10_base.stop() {
        cl "stopping postgres server 10 ... "
        sudo service postgresql stop || {
            cl "failed to stop the postgres server 10 ... " -e
            return 1
        }
        cl "postgres server 10 has been stopped ... " -s
        return 0
    }

    # Create databses
    provision.postgres10_base.createDb() {
        local __db_name="${1}"
        cl "checking database \"${__db_name}\" has been installed ... "
        if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw "${__db_name}"; then
            cl "postgres database \"${__db_name}\" already exists ... " -w
        else
            cl "\"${__db_name}\" database has not been created ... " -f
            cl "attempting to create \"${__db_name}\" database ... "

            sudo -u postgres createdb -O root "${__db_name}" || {
                cl "failed to create the postgres \"${__db_name}\"  database ... " -e
                return 1
            }
            cl "\"${__db_name}\"  database  has been created ... " -s

        fi
        return 0
    }

}
