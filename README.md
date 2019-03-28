# Modul 300 - Leistungsbeurteilung 1
## Übersicht
[Aufgabenstellung](https://docs.google.com/document/d/1KllAAPJCIlcV3jMipyCw3mPliOTVDEZAuUSzTxQEypY/edit#heading=h.nt6gsj7ju1fi)<br/>
[Bewertungsraster](https://docs.google.com/spreadsheets/d/1pYWn2r7XU3TdtXS01yqfUPGO35MyJu1hdMYNpq5i8Fk/edit#gid=1761970523)<br/>

## K1 - Umgebung auf eigenem Notebook eingerichtet und funktionsfähig
### VirtualBox
[VirtualBox Download](https://www.virtualbox.org/wiki/Downloads)<br/>
Virtualbox herunterladen und installieren.<br/>
Für die Standardinstallation welche mit Vagrant funktioniert benötigt die installation keine weiteren konfigurationen.

### Vagrant
[Vagrant Download](https://www.vagrantup.com/downloads.html)<br/>
Vagrant herunterladen und installieren.<br/>
Für die Standardinstallation müssen keine weiteren konfigurationen vorgenommen werden.
* Achtung! Das OS muss nach einer erfolgreichen Installation von Vagrant neugestartet werden.

### Visual Studio Code
[Visual Studio Code Download](https://code.visualstudio.com/download)<br/>
Die passende Version von Visual Studio Code herunterladen und installieren.<br/>
Für die Standardinstallation müssen keine weiteren konfigurationen vorgenommen werden.<br/>
Sobald im nächsten Schritt der Git-Bash Client installiert wurde, kann dieser innerhalb von Visual Studio Code als Terminal verwendet werden.

### Git-Client / Git-Bash / Git-Desktop
[Git-Bash Download](https://git-scm.com/downloads)
Die passende Version von Git-Bash herunterladen und installieren.

#### Konfiguration
Wird im Repository angezeigt (Von wem dies das).

   ### Netzwerkplan

    +--------------------+          +--------------------+          +---------------------+
    ! Proxy Server       !          ! Web Server         !          ! Datenbank Server    !
    ! Host: proxy        !          ! Host: web          !          ! Host: db            !
    ! IP: 192.168.40.99  ! <------> ! IP: 192.168.40.100 ! <------> ! IP: 192.168.40.101  !
    ! Port: 5000         !          ! Port: 80           !          ! Port 3306           !
    ! Nat: 5000          !          ! Nat: -             !          ! Nat: -              !
    +--------------------+          +--------------------+          +---------------------+
    
# Envirement Setup
Git - Versionverwaltung (Zum einfachen download von Git Umgebungen)
Download: https://git-scm.com/download/win
Install

Ich habe aus dem GitHub M300 Verzeichniss die MMDB synchronsiert und lauffähig.

## Automatisierte Wordpress installation
Ganzes Vagrantfile [hier](https://github.com/fxshell/wordpressenv/blob/master/Vagrantfile)
Wordpress ist ein freies Content-Management System mit dem es Möglich ist schnell optisch sehr ansprechende Websites zu erstellen.

Die Installation wird in folgende Schritte unterteilt:
1. Installation des Webservers
2. Installation und aufsetzen von MySQL auf dem Database Server.
3. Herunterladen von Wordpress
4. Kopieren des Config-Files
5. Profit!


### Wordpress install im Vagrantfile
    #Installaton des Webservers
    sudo apt-get -y install php libapache2-mod-php php-curl php-cli php-mysql php-gd mysql-client  
    
    # Herunterladen von Wordpress
    cd /var/www/html
    wget -c http://wordpress.org/latest.tar.gz
    # entpacken des Verzeichnisses
    tar -xzvf latest.tar.gz
    # Rechtevergabe an denn www-data User für Zugriff
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
Das Config file wir im Shared Folder abgelegt und dann per Vagrant file in das richtige Verzeichnis */var/www/html/wordpress* verschoben.

    /** The name of the database for WordPress */
    define('DB_NAME', 'wordpress');

    /** MySQL database username */
    define('DB_USER', 'wordpressuser');

    /** MySQL database password */
    define('DB_PASSWORD', 'securewordpresspw');

    /** MySQL hostname */
    define('DB_HOST', '192.168.1.100');


## K4 - Sicherheitsaspekte sind implementiert
### Firewall eingerichtet inkl. Rules

#### UFW Rules pro VM
UFW wurde wie folgt eingerichtet:
  
    echo "y" | sudo ufw enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow 80
    sudo ufw allow 443
    sudo ufw allow ssh
    sudo ufw allow 3306
    
### Zugang mit SSH-Tunnel abgesichert
Auf die VagrantVMs kommt man nur via SSH. SSH ist, wie der Name schon sagt, standardmässig verschlüsselt (Secure Shell).
Dazu wird durch Vagrant selber der Stadard SSH Port 22 auf einen anderen freien weitergeleitet, sodass ein potenzieller Angreifer gar nicht erst eine Verbindung aufbauen kann.
Falls man möchte, kann man auch wie [hier](https://github.com/chltrx/m300-lb1-widmer#k3---vagrant) beschrieben, eine manuelle SSH Verbindung aufbauen und den generierten Private Key angeben.
Vagrant generiert dazu noch zu jeder neu erstellten VM einen neue Public & Privat Key.

### Benutzer- und Rechtevergabe ist eingerichtet pro VM

| VM                | Benutzer | Recht |
| -------------------------|:----------------------:|-----------------:|
| ubuntu   | vagrant   | root   |
| ubuntu | root                | root   |
| database                      | vagrant                | root |
| database  | root |    root|
| web   | vagrant   | root  |
| database (MySQL) | root| Zugriff auf alle Datenbanken |

### Projekt mit Git und Markdown dokumentiert
Ja!

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
