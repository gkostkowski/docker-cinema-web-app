# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/xenial64"
    db.vm.hostname = "dbhost"
    db.vm.network "private_network", ip: "192.168.50.2"
    db.vm.provision "shell", privileged: true, path: "bootstrap_db.sh"
  end

  config.vm.define "www" do |www|
    www.vm.box = "ubuntu/xenial64"
    www.vm.hostname = "wwwhost"
    www.vm.network "private_network", ip: "192.168.50.3"
    www.vm.network "forwarded_port", guest:8080, host:8088
    www.vm.provision "shell", privileged: true, path: "bootstrap_web_app.sh"
  end

end
