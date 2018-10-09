#!/usr/bin/env bash
import.require 'provision>base'

provision.wordpress_base.init() {
    provision.wordpress_base.__init() {
        cl "====== wordpress ====== "
        import.useModule 'provision_base'
    }
    provision.wordpress_base.installWordpressCli() {
        cl "checking to see if wordpress cli is installed ... "
        if [ ! -f "/usr/local/bin/wp" ]; then
            cl "wordpress cli is not installed ... " -f
            cl "attempting to install wordpress cli  ... "
            curl -sS -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar || {
                cl "failed to download the wordpress cli installer ... " -e
                return 1
            }
            cl "attempting to update the permissions on wp-cli.phar ... "
            sudo chmod +x wp-cli.phar || {
                cl "failed to change the permissions on wp-cli.phar ... " -e
                return 1
            }
            cl "permissions on wp-cli.phar updated ... " -s
            cl "attempting to move wp-cli.phar to /usr/local/bin/wp ... "
            sudo mv wp-cli.phar /usr/local/bin/wp || {
                cl "failed to move wp-cli.phar to /usr/local/bin/wp ... " -e
                return 1
            }
            cl "wp-cli.phar has been moved ... " -s
        else
            cl "wordpress cli is already installed ... " -w
            return 1
        fi
      return 0
  }

  provision.wordpress_base.installWordpress() {
        local __db_name="${1}"
        cl "checking to see if wordpress is installed ... "
        # Install Wordpress
        if [ ! -f "/var/www/html/wp-config.php" ]; then

            cl "wordpress is not installed ... " -f
            cl "attempting to install wordpress  ... "

            # Create the wp-cli.yml
            local __wp_cli="/var/www/html/wp-cli.yml"
            cl "attempting to create ${__wp_cli} ... "
            sudo touch "${__wp_cli}" || {
                cl "failed to create ${__wp_cli} ... " -e
            }
            cl "${__wp_cli} has been created ... " -s
            local __block="
apache_modules:
  - mod_rewrite
            "
            echo "${__block}" | sudo tee "${__wp_cli}" > /dev/null

            # Download Wordpress
            cl "attempting to download wordpress ... "
            # sudo chown -R vagrant:vagrant /var/www/html/
            # cd /var/www/html/
            sudo wp core download --path=/var/www/html/ --allow-root --locale=sv_SE --force > /dev/null 2>&1 || {
                cl "failed to download wordpress ... " -e
                return 1
            }
            cl "wordpress has been downloaded ... " -s

            # Create config file
            cl "attempting to create the wp-config.php ...."
            sudo wp --allow-root core config --dbname=${__db_name} --dbuser=root --dbpass=password --dbhost=localhost --path=/var/www/html/ > /dev/null 2>&1 || {
                cl "failed to create wp-config.php ... " -e
                return 1
            }
            cl "wp-config has been created ... " -s

            # Install Wordpress
            cl "attempting to install wordpress packages ... "
            sudo wp core install --allow-root --url='http://localhost' --title='wordpress' --admin_user='admin' --admin_email='noreply@monkii.com' --admin_password='password' --path=/var/www/html/ > /dev/null 2>&1 || {
                cl "failed to install wordpress packages ... " -f
            }
            cl "worpress packages have been installed ... " -s

            # This creates the .htaccess file
            cl "attempting to create .htaccess ... "
            cd /var/www/html/
            sudo wp rewrite structure '/%postname%' --hard --allow-root > /dev/null 2>&1 || {
                "failed to create .htaccess ... " -e
            }
            cl ".htacces has been ctreated ... " -s

        else
            cl "wordpress is already installed ... " -w
            return 1
        fi
      return 0
    }

    provision.wordpress_base.installHtaccess() {
        cl "checking to see if wordpress cli is installed ... "

        # This creates the .htaccess file
        cl "attempting to create .htaccess ... "
        sudo wp rewrite structure '/%postname%' --hard --allow-root || {
            "failed to create .htaccess ... " -e
        }
        cl ".htacces has been ctreated ... " -s


        if [ ! -f "/usr/local/bin/wp" ]; then
            cl "wordpress cli is not installed ... " -f
            cl "attempting to install wordpress cli  ... "
            curl -sS -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar || {
                cl "failed to download the wordpress cli installer ... " -e
                return 1
            }
            cl "attempting to update the permissions on wp-cli.phar ... "
            sudo chmod +x wp-cli.phar || {
                cl "failed to change the permissions on wp-cli.phar ... " -e
                return 1
            }
            cl "permissions on wp-cli.phar updated ... " -s
            cl "attempting to move wp-cli.phar to /usr/local/bin/wp ... "
            sudo mv wp-cli.phar /usr/local/bin/wp || {
                cl "failed to move wp-cli.phar to /usr/local/bin/wp ... " -e
                return 1
            }
            cl "wp-cli.phar has been moved ... " -s
        else
            cl "wordpress cli is already installed ... " -w
            return 1
        fi
      return 0
  }

}
