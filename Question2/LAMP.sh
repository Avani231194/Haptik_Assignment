#!/bin/bash
echo "############################## Updating packages ##########################################"
sudo apt-get update -y
echo "############################# Update done ############################################"
echo "############################ Installing Apache2 #######################################"
sudo apt-get install apache2 -y
echo "############################# checking syntax #############################################"
sudo apache2ctl configtest
echo "################################# Apache done and now Installing Mysql Server ############################"
sudo apt-get install mysql-server -y
echo "#####################Installation Done ##########################################"
sudo apt-get install aptitude -y
sudo aptitude -y install expect

MYSQL_ROOT_PASSWORD=abcd1234

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")
echo "$SECURE_MYSQL"

sudo aptitude -y purge expect
echo "############################## Installing PHP #######################################"

sudo apt-get install php libapache2-mod-php -y
echo "################ Checking PHP Version ###########################################"
php -version
sudo touch /var/www/html/info.php
sudo chown ubuntu.ubuntu /var/www/html/info.php
sudo chmod 775 -R /var/www/html/info.php
> /var/www/html/info.php
echo "<?php
 
phpinfo();
 
?>" >> /var/www/html/info.php

sudo systemctl restart apache2
echo "########################Restart done ######################################"
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
chmod 660 /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
#mkdir /tmp/wordpress/wp-content/upgrade
echo "############################### Doneeeee ##################################"
sudo cp -a /tmp/wordpress/. /var/www/html
sudo chown -R ubuntu:ubuntu /var/www/html
sudo find /var/www/html -type d -exec chmod g+s {} \;
sudo chmod 775 /var/www/html/wp-content
sudo chmod -R 775 /var/www/html/wp-content/themes
sudo chmod -R 775 /var/www/html/wp-content/plugins
echo "######################PROGRESS########################"
sudo cp -r /var/www/html/wp-config.php /var/www/html/wp-config.php_bck
sed -i '/put your unique phrase here/d' /var/www/html/wp-config.php
curl -s https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-config.php
echo "Enter Database name for wordpress"
read database_name
sed -i -- 's/database_name_here/$database_name/g' /var/www/html/wp-config.php
echo "Enter Username for wordpress"
read username
sed -i -- 's/username_here/$username/g' /var/www/html/wp-config.php
echo "Enter password for wordpress"
read password
sed -i -- 's/password_here/$password/g' /var/www/html/wp-config.php
echo "#################################copying content #########################################"
sudo rsync -avP /tmp/wordpress/ /var/www/html/
cd /var/www/html
sudo chown -R ubuntu:ubuntu *
mkdir -p /var/www/html/wp-content/uploads
sudo chown -R ubuntu:ubuntu /var/www/html/wp-content/uploads
echo "########################Completed####################################################"