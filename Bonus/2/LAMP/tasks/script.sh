#!/bin/bash
echo "##########################Installing Wordpress###########################"
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
chmod 660 /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir -p /tmp/wordpress/wp-content/upgrade
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
