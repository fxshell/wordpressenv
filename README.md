# M300-Services
----------------------

### Übersicht 

    +---------------------------------------------------------------+
    ! Notebook - Schulnetz 10.x.x.x und Privates Netz 192.168.1.1   !                 
    ! Port: 8080 (192.168.55.1:80)                                  !	
    !                                                               !	
    !    +--------------------+          +---------------------+    !
    !    ! Web Server         !          ! Datenbank Server    !    !       
    !    ! Host: web01        !          ! Host: db01          !    !
    !    ! IP: 192.168.1.101  ! <------> ! IP: 192.168.1.100   !    !
    !    ! Port: 80           !          ! Port 3306           !    !
    !    ! Nat: 8080          !          ! Nat: -              !    !
    !    +--------------------+          +---------------------+    !
    !                                                               !	
    +---------------------------------------------------------------+

# Envirement Setup
Git - Versionverwaltung (Zum einfachen download von Git Umgebungen)
Download: https://git-scm.com/download/win
Install

### SSH-Key für Client
Der SSH-Key wurde mit dieser [Anleitung](https://github.com/mc-b/M300/tree/master/10-Toolumgebung#ssh-key-erstellen-lokal) erstellt und zum privaten GitHub Account hinzugefügt.
* Der Public SSH-Key "id_rsa.pub" wurde im GitHub Account hinzugefügt.
* Der Privat SSH-Key "id_rsa" befindet sich unter "%HOMEPATH%\".ssh"\" ("C:\Users\Till\".ssh"\")
* 
# Git Basics
    create a new repository
    create a new directory, open it and perform a 
    git init
to create a new git repository.

#### Konfiguration
Wird im Repository angezeigt (Von wem dies das).

    git config --global user.name "<username>"
    git config --global user.email "<e-mail>"

checkout a repository
create a working copy of a local repository by running the command
    git clone /path/to/repository
when using a remote server, your command will be
    git clone username@host:/path/to/repository

## Bestehndes Environment starten
    In einem vorhandenem environment sind alle Einstellungen schon vorkonfiguriert. Ganze Umgebungen mit sämtlichen Einst
    Git Bash starten
    Repo clonen
        Ø git clone https://github.com/fxshell/M300-Services
        Ø Cd M300-Services
        Ø Vagrant up
    Die VM wird gestartet.
    Login mit:
	    Ø Vagrant ssh

## Common commands:
     box             manages boxes: installation, removal, etc.
     cloud           manages everything related to Vagrant Cloud
     destroy         stops and deletes all traces of the vagrant machine
     global-status   outputs status Vagrant environments for this user
     halt            stops the vagrant machine
     help            shows the help for a subcommand
     init            initializes a new Vagrant environment by creating a Vagrantfile
     login
     package         packages a running vagrant environment into a box
     plugin          manages plugins: install, uninstall, update, etc.
     port            displays information about guest port mappings
     powershell      connects to machine via powershell remoting
     provision       provisions the vagrant machine
     push            deploys code in this environment to a configured destination
     rdp             connects to machine via RDP
     reload          restarts vagrant machine, loads new Vagrantfile configuration
     resume          resume a suspended vagrant machine
     snapshot        manages snapshots: saving, restoring, etc.
     ssh             connects to machine via SSH
     ssh-config      outputs OpenSSH valid configuration to connect to the machine
     status          outputs status of the vagrant machine
     suspend         suspends the machine
     up              starts and provisions the vagrant environment
     upload          upload to machine via communicator
     validate        validates the Vagrantfile
     version         prints current and latest Vagrant version
     winrm           executes commands on a machine via WinRM
     winrm-config    outputs WinRM configuration to connect to the machine

# Neue Vagrant Umgebung aufsetzen
## Basics Vagrant Boxes
vagrant box add https://app.vagrantup.com/ubuntu/boxes/trusty64

Before you start you need to add new Boxes to your environment. 
Boxes are the package format for Vagrant environments. A box can be used by anyone on any platform that Vagrant supports to bring up an identical working environment.
The easiest way to use a box is to add a box from the publicly available catalog of Vagrant boxes. You can also add and share your own customized boxes on this website.
Also you can upload and share your own boxes easily.

## Basics Vagrantfile 
The primary function of the Vagrantfile is to describe the type of machine required for a project, and how to configure and provision these machines. Vagrantfiles are called Vagrantfiles because the actual literal filename for the file is Vagrantfile (casing does not matter unless your file system is running in a strict case sensitive mode).
Vagrant is meant to run with one Vagrantfile per project, and the Vagrantfile is supposed to be committed to version control. This allows other developers involved in the project to check out the code, run vagrant up, and be on their way. Vagrantfiles are portable across every platform Vagrant supports.
    Commands:
    Vagrant-Box vom Netzwerkshare hinzufügen
        Ø vagrant box add http://10.1.66.11/vagrant/ubuntu/xenial64.box --name ubuntu/xenial64  
    Show added Boxed
        Ø Vagrant box list
    Vagrantfile erzeugen
        Ø vagrant init ubuntu/xenial64          
    Virtuelle Maschine erstellen & starten
        Ø vagrant up
    Mit der VM verbinden 
        Ø Vagrant ssh

## Wordpress automated install
Um Wordpress zu installieren muss das LAMP Stack installiert sein. (Alle commands unten.)

Danach ziehen wir die Wordpress Dateien vom Server und entpacken sie im /var/www/html Verzeichniss.
Wir geben dem Nutzer www-data noch recursive die Rechte für das Verzechniss.

Danach kopieren wir das vorkonfigurierte wp-config file welches wir über den Shared Ordner hochgeladen haben noch in das richtige Verzeichniss.

### Wordpress install im Vagrantfile
    
    sudo apt-get -y install php libapache2-mod-php php-curl php-cli php-mysql php-gd mysql-client  
    cd /var/www/html
    wget -c http://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz
    chown -R www-data:www-data /var/www/html/wordpress
    
    # config file kopieren
    cp /var/www/html/wp-config.php /var/www/html/wordpress/wp-config.php

Inhalt Config file:
Hier müssen wir die IP des Datenbank Servers angeben sowie Username und Passwort für den Mysql User den wir erstellt haben.
    
User fuer Remote Zugriff einrichten - aber nur fuer Host web 192.168.1.101

### mysql Nutzer erstellen auf datenbank server

    mysql -uroot -pS3cr3tp4ssw0rd <<%EOF%
	CREATE DATABASE wordpress;
	CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'securewordpresspw';
	GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'localhost';
	CREATE USER 'wordpressuser'@'192.168.1.101' IDENTIFIED BY 'securewordpresspw';
	GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'192.168.1.101';
	FLUSH PRIVILEGES;
    %EOF%

### Wordpress config file
    /** The name of the database for WordPress */
    define('DB_NAME', 'wordpress');

    /** MySQL database username */
    define('DB_USER', 'wordpressuser');

    /** MySQL database password */
    define('DB_PASSWORD', 'securewordpresspw');

    /** MySQL hostname */
    define('DB_HOST', '192.168.1.100');


## Sicherheitsaspekte sind implementiert
### Firewall eingerichtet inkl. Rules

#### UFW Rules pro VM
#enabling firewall
  echo "y" | sudo ufw enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow 80
    sudo ufw allow 443
    sudo ufw allow ssh
    sudo ufw allow 3306

### Benutzer- und Rechtevergabe ist eingerichtet pro VM

| VM                | Benutzer | Recht |
| -------------------------|:----------------------:|-----------------:|
| ubuntu   | vagrant   | root   |
| ubuntu | root                | root   |
| database                      | vagrant                | root |
| database  | root |    root|
| web   | vagrant   | root  |
| database (MySQL) | root| Zugriff auf alle Datenbanken |

#### database
| Testfall                | Beschreibung | Ergebnis |
| :-----------------------|:----------------------:|:-----------------------:|
| SSH Verbindung          | Funktioniert eine SSH-Verbindung zur VM via vagran ssh database? | Die SSH Verbindung funtkioniert einwandfrei. |
| Zugriff auf die MySQL Datenbank | Kann über das Web-Interface Adminer auf die MySQL Datenbank zugegriffen werden? | Ja, der Zugriff funktioniert einwandfrei. |

#### web
| Testfall                | Beschreibung | Ergebnis |
| :-----------------------|:----------------------:|:-----------------------:|
| SSH Verbindung          | Funktioniert eine SSH-Verbindung zur VM via vagran ssh web? | Die SSH Verbindung funtkioniert einwandfrei. |
| Zugriff auf das Wordpress Web-Interface | Kann das Wordpress Web-Interface aufgerufen werden? | Ja, der Zugriff funktioniert einwandfrei. |
| Zugriff auf die apache2 Defaultsite | Kann die apache2 Defaultsite aufgerufen werden? | Ja, der Zugriff funktioniert einwandfrei. |


### Persönliche Lernentwicklung
#### Vergleich Vorwissen - Wissenszuwachs

##### Linux
Einen grossen Wissenszuwachs bezüglich Linux gibt es nach dieser LB nicht wirklich. Auch neue Bash Commands habe ich nicht wirklich entdeck. Diese LB hat hauptsächlich dazu beigetragen, dass Vorwissen über Linux & Bash wieder aufzufrischen. Dazu bin ich jetzt auch etwas vertrauter mit Linux & Bash.

##### Virtualisierung
Der Wissenszuwachs bei der Virtualisierung ist auch nicht wirklich gross. Daher ich VirtualBox schon vorher kannte ist dies auch nichts neue. VirtualBox wurde auch nicht wirklich "aktiv" selber gebraucht, nur via Vagrant. Die ganze LB1 könnte man auch erledigen ohne VirtualBox einmal zu starten.

##### Vagrant
Den wohl grössten Wissenszuwachs habe ich beim Programm Vagrant. Ich kannte diese Programm zuvor überhaupt nicht und habe auch noch nie davon gehört. Änliche Programme kanne ich zwar bereits allerdings funktioniert Vagrant etwas anders. Hauptsächlich ist Vagrant näher am System und Vagrant macht auch nur die Dinge, welche vom User gewünscht bzw. im Vagrantfile eingetragen wurde. Ich denke, dass ich jetzt gegen ende der LB1 einigermassen verstehe wie Vagrant funktioniert. Ich weis jetzt wie das Vagrantfile ungefähr funktioniert und wie ich das ganze auch anwenden und benutzen kann.

##### Versionsverwaltung
Bei der Versionsverwaltung habe ich nicht wirklich etwas dazu gelernt. Mein Vorwissen wurde eifach ein wenig aufgefrischt.

##### GitHub
Bei GitHub wurde mein Vorwissen ebefalls etwas aufgefrischt, daher ich GitHub schon etwas länger nicht mehr verwendet habe. Dazu kenne ich jetzt die Git Commands etwas besser und muss nicht immer einen Client mit GUI verwenden um Repositories zu verwalten.

##### Markdown
Bei Markdown habe ich ein paar neue "Befehle" dazu gelernt und weis jetzt etwas besser, wie Markdown funtkioniert bzw. wie man es einsetzten kann.

##### Systemsicherheit
Zur Systemsicherheit habe ich eigentlich nichts neues dazu gelernt. Dinge wie die UFW Firewall zu konfigurieren oder das man Standardports weiterleitet kenne ich bereits und habe dies auch schon Privat und Geschäftlich angewendet. Allerdings habe ich zuvor noch nie wirklich mit Public & Private SSH Keys gearbeitet. Wie das ganze mit den SSH Keys funktioniert weis ich immernoch nicht zu 100%.

#### Reflexion
Alles in eimem fand ich diese Modul bis jetzt sehr informativ und es ist im Vergleich zu den vorherigen TBZ Modulen sehr spannend. Sehr gut finde ich, dass vom Produkt (LB1 mit Vagrant usw.) bis zur Dokumentation mit Markdown alles sehr gut zum Beruf Informatiker passt. Eine Dokumentation mit Markdown zu erstellen ist definitiv etwas anderes als eifach ein weiteres Word Dokument zu erstellen. Ebenfalls ist dies das erste Modul in dem Verlang wird GitHub zu verwenden. Bei vielen vorherigen Modulen würde GitHub sehr gut als ersatzt für BSCW dienen. Das alle Informationen, Aufträge, usw. mit Google Docs gemacht wurden ist sehr Zeitgemäss und viel einfach als Tausende Dokumente von BSCW herunter zu laden. Man bleibt so immer auf dem neusten stand und man muss nicht immer wieder neue Dokumente herunterladen. Am Anfang war für mich zwar sehr vielen Unklar und ich wusste nicht wirklich wo ich beginnen sollte. Allerdings ist Vagrant ziemlich gut beschrieben und es gibt auch eine, so wie ich mit bekmmen habe, grosse Community dahinter, sodass man immer eine Lösung für ein vorhandenes Problem findet. Bis jetzt hat mir dieses Modul im Vergleich zu den anderen TBZ Modulen am besten gefallen.