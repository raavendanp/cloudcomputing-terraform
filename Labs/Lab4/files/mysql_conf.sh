#!/bin/bash
sudo yum update -y
sudo yum install mariadb-server -y
sudo systemctl start mariadb
sudo mysql_secure_installation
sudo mysql -uroot -p
CREATE DATABASE wordpress;
show databases;
CREATE USER "wpuser"@"localhost" IDENTIFIED BY "wppassword";
GRANT ALL PRIVILEGES ON *.* TO "wpuser"@"localhost";
FLUSH PRIVILEGES;
CREATE USER "wpuser"@"privateipwebserver" IDENTIFIED BY "wppassword";
GRANT ALL PRIVILEGES ON *.* TO "wpuser"@"privateipwebserver";
FLUSH PRIVILEGES;
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/my.cnf;
sudo /usr/libexec/mysqld restart
