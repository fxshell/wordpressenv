# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  
  config.vm.define "proxy" do |proxy|
		proxy.vm.box = "ubuntu/xenial64"
		proxy.vm.hostname = "proxy"
		proxy.vm.network "private_network", ip: "192.168.1.99"
		proxy.vm.network "forwarded_port", guest:80, host:5000, auto_correct: true
		proxy.vm.provider "virtualbox" do |vb|
			vb.memory = "512"  
		end
		proxy.vm.synced_folder "proxy", "/vagrant"  
		proxy.vm.provision "shell", path: "proxy.sh"
  end
  
  config.vm.define "database" do |db|
       db.vm.box = "ubuntu/xenial64"
	    db.vm.provider "virtualbox" do |vb|
	      vb.memory = "512"  
	    end
    db.vm.hostname = "db01"
    db.vm.network "private_network", ip: "192.168.1.100"
    # MySQL Port nur im Private Network sichtbar
  	# db.vm.network "forwarded_port", guest:3306, host:3306, auto_correct: false
  	db.vm.provision "shell", path: "db.sh"
  end
  
  config.vm.define "web" do |web|
    web.vm.box = "ubuntu/xenial64"
    web.vm.hostname = "web01"
    web.vm.network "private_network", ip:"192.168.1.101" 
    web.vm.network "forwarded_port", guest:10000, host:1337, auto_correct: true
    web.vm.network "forwarded_port", guest:80, host:8080, auto_correct: true
  	web.vm.provider "virtualbox" do |vb|
	  vb.memory = "512"  
	end     
  	web.vm.synced_folder ".", "/var/www/html"  
  	web.vm.provision "shell", inline: <<-SHELL
		sudo apt-get update
		sudo apt-get -y install debconf-utils apache2 nmap
		sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password admin'
		sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password admin'
		sudo apt-get -y install php libapache2-mod-php php-curl php-cli php-mysql php-gd mysql-client  
    cd /var/www/html
    wget -c http://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz
    chown -R www-data:www-data /var/www/html/wordpress

    # config file kopieren
    cp /var/www/html/wp-config.php /var/www/html/wordpress/wp-config.php
    
    # enabling firewall
   # echo "y" | sudo ufw enable
    #sudo ufw default deny incoming
    #sudo ufw default allow outgoing
    #sudo ufw allow 80
    #sudo ufw allow 443
    #sudo ufw allow ssh
    #sudo ufw allow 3306

  

SHELL
	end  
 end
