#!/bin/bash
sudo yum update -y 
sudo amazon-linux-extras install nginx1.12 -y 
sudo sed -i "s/root         \/usr\/share\/nginx\/html;/root         \/usr\/share\/nginx\/html\/bookstore;/" /etc/nginx/nginx.conf 
sudo mkdir /usr/share/nginx/
sudo mkdir /usr/share/nginx/html
sudo mkdir /usr/share/nginx/html/bookstore
sudo chmod 777 /usr/share/nginx/html/bookstore
sudo yum install git -y
sudo git clone https://github.com/Course-ST0911/2022-1.git front/
sudo mv front/BookStore/frontend/* /usr/share/nginx/html/bookstore/
sudo rm -r /usr/share/nginx/html/bookstore/BookStore/
sudo yum install -y gcc-c++ make 
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install -y nodejs 
cd /usr/share/nginx/html/bookstore/
npm install 
npm run build 
sudo chmod 777 /usr/share/nginx/html/bookstore/ 
systemctl status nginx.service 
systemctl start nginx.service
chkconfig nginx on
