# M300-Services

# Envirement Setup
Git - Versionverwaltung (Zum einfachen download von Git Umgebungen)
Download: https://git-scm.com/download/win
Install

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
Um Wordpress 


# Git Basics
    create a new repository
    create a new directory, open it and perform a 
    git init
to create a new git repository.

checkout a repository
create a working copy of a local repository by running the command
    git clone /path/to/repository
when using a remote server, your command will be
    git clone username@host:/path/to/repository

## Sicherheitsaspekte sind implementiert
### Firewall eingerichtet inkl. Rules
Die UFW Firewall wurde wie [hier](https://github.com/chltrx/m300-lb1-widmer#zugang-mit-ssh-tunnel-abgesichert) beschrieben eingeschaltet.

#### UFW Rules pro VM
##### Ubuntu VM (Nicht implementiert)

    ufw enabled
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh


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
