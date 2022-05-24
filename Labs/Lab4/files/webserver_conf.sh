#!/bin/bash
sudo apt-get update -y
sudo apt-get install apache2 -y 
sudo apt-get install php libapache2-mod-php php-mysql -y
sudo apt-get install php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip -y 
sudo systemctl restart apache2
sudo mkdir /var/www
sudo mkdir /var/www/wordpress
sudo sed -i "s/DocumentRoot.*/DocumentRoot \/var\/www\/wordpress \n \t <Directory \/var\/www\/wordpress\/> \n \t AllowOverride All \n \t <\/Directory> /"  /etc/apache2/sites-available/000-default.conf
sudo a2enmod rewrite
sudo systemctl restart apache2
sudo mkdir descarga
sudo wget https://wordpress.org/latest.tar.gz -P /descarga
sudo tar zxvf /descarga/latest.tar.gz
sudo cp wordpress/wp-config-sample.php wordpress/wp-config.php
sudo sed -i "s/database_name_here/${db_name}/" wordpress/wp-config.php
sudo sed -i "s/username_here/${db_user}/" wordpress/wp-config.php
sudo sed -i "s/password_here/${db_pass}/" wordpress/wp-config.php
sudo sed -i "s/localhost/${db_host}/" wordpress/wp-config.php
sudo cp -a wordpress/. /var/www/wordpress
sudo chown -R www-data:www-data /var/www/wordpress
sudo find /var/www/wordpress/ -type d -exec chmod 750 {} \;
sudo find /var/www/wordpress/ -type f -exec chmod 640 {} \;