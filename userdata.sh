#!/bin/bash

yum install httpd -y
service httpd start
chkconfig httpd on
mkdir "/var/www/html"
echo "<h1>Welcome to StuDocu</h1>" > /var/www/html/index.html
echo "Configured Successfully"