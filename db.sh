#!/bin/bash
#
#	Datenbank installieren und Konfigurieren
#

# root Password setzen, damit kein Dialog erscheint und die Installation haengt!
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password S3cr3tp4ssw0rd'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password S3cr3tp4ssw0rd'

# Installation
sudo apt-get install -y mysql-server

# MySQL Port oeffnen
sudo sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# User fuer Remote Zugriff einrichten - aber nur fuer Host web 192.168.55.101
mysql -uroot -pS3cr3tp4ssw0rd <<%EOF%
	CREATE DATABASE wordpress;
	CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'securewordpresspw';
	GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
	CREATE USER 'wordpressuser'@'192.168.1.101' IDENTIFIED BY 'securewordpresspw';
	GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'192.168.1.101';
	FLUSH PRIVILEGES;
%EOF%

# Restart fuer Konfigurationsaenderung
sudo service mysql restart

# enabling firewall
    echo "y" | sudo ufw enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow 80
    sudo ufw allow 443
    sudo ufw allow ssh
    sudo ufw allow 3306
