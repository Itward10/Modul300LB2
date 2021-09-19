# Vagrant anwendung

Vagrant ist eine Software die dazu dient für einfache Softwareverteilung. Auf der Vagrant Website findet man allerlei Packete zur Installation von Betriebssysteme. Sie ist eine kommunikation zwischen Virtualisierungssoftware und Systemkonfigurationswerkzeuge. 

Zuerst erstellt man ein Ordner und dort drinnen Vagrant File. Dieses fängt man an mit:

```ruby

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
end

```

In diesem Beispiel oben nehme ich das Paket ubuntu/xenial64.
Dies findet man auch auf ihrer offizielle Website:
![image](https://user-images.githubusercontent.com/89509863/133934602-d33b479a-b156-4f5d-96eb-6cb683dfa686.png)

Vagrant zieht das Packet runter auf den Lokalen PC/Server und setzt die vm auf.

Mit dem **config.vm** Namensraum kann man die konfiguration bestimmen von der vm selber.


```ruby config.vm.box = "ubuntu/xenial64" ``` 

```ruby config.vm.network "forwarded_port", guest:80, host:8080, auto_correct: true``` Netzwerkeinstellung an der VM selber

```ruby config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = 2
``` 
Auswahl der Virtualisierungssoftware und den Hardware angaben
