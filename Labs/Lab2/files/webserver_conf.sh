#!/bin/bash
sudo yum update -y
sudo yum remove httpd* php*
sudo yum install httpd -y
sudo sed -i 's/.*ServerName w.*/ServerName localhost:80/' /etc/httpd/conf/httpd.conf
sudo service httpd start
sudo chkconfig httpd on
sudo groupadd www
sudo usermod -a -G www ec2-user
groups
sudo chgrp -R www /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} +
find /var/www -type f -exec sudo chmod 0664 {} +
#Verifique por consola que el servidor web se esta ejecutando de forma correcta.
curl localhost
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php-cli php-pdo php-fpm php-json php-mysqlnd php-gd -y
sudo printf "<?php\nphpinfo();\n?>\n" > /var/www/html/test.php
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
sudo sed -i "s/database_name_here/${db_name}/" wordpress/wp-config.php
sudo sed -i "s/username_here/${db_user}/" wordpress/wp-config.php
sudo sed -i "s/password_here/${db_pass}/" wordpress/wp-config.php
sudo sed -i "s/localhost/${db_host}/" wordpress/wp-config.php
mkdir /var/www/html/blog
cp -r wordpress/* /var/www/html/blog/
sudo sed -i 's/  AllowOverride.*/  AllowOverride All/'  /etc/httpd/conf/httpd.conf
sudo service httpd restart