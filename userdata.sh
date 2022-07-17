#!/bin/bash

sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo chkconfig httpd on
sudo mkdir -p "/var/www/html"
echo "<h1>Welcome to StuDocu</h1>" | sudo tee -a /var/www/html/index.html
