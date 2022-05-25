#!/bin/bash
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update -y
sudo apt-get install apt-transport-https ca-certificates  curl  gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce -y
sudo docker container run hello-world
sudo docker info
sudo systemctl start docker
sudo mkdir mywebserver2
cd mywebserver2
sudo bash -c 'cat <<EOT >> test.html
<!doctype html>
<html lang="en">
<head>
 <meta charset="utf-8">
 <title>Docker Apache</title>
</head>
<body>
 <h2>Hello from Apache Web Server container...</h2>
</body>
</html>
EOT'
sudo bash -c 'cat <<EOT >> Dockerfile
FROM httpd:2.4
COPY ./test.html /usr/local/apache2/htdocs/
EOT'
sudo docker build -t my-apache2 .
sudo docker run -dit --name my-running-app -p 8080:80 my-apache2
sudo docker container ps
cd ..
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose --version
sudo mkdir dk_wordpress
cd dk_wordpress/
sudo bash -c 'cat <<EOT >> docker-compose.yml
version: "3.1"
services:  
  wordpress:
    depends_on:
      - db
    image: wordpress:latest
    volumes:
      - wordpress_data:/var/www/html
    ports:
      - "80:80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: somewordpress
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress  
volumes:
  db_data: {}
  wordpress_data: {}
EOT'
 