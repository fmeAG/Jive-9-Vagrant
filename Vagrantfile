# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # vagrant box add centos65-x86_64-20140116 https://github.com/2creatives/vagrant-centos/releases/download/v6.5.3/centos65-x86_64-20140116.box
  config.vm.box = "centos65-x86_64-20140116"
  config.vm.post_up_message = "Environment Ready. For the first time, please check http://localhost:9080 on your host to install the database."
  config.vm.provision "shell", path: "setup.sh"
  
  #config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  
  #see https://github.com/dotless-de/vagrant-vbguest
  #config.vbguest.auto_update = true
  #config.vbguest.no_remote = false



  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "12096"]
    v.customize ["modifyvm", :id, "--cpus", "4"] 
	v.customize ["modifyvm", :id, "--ioapic", "on"]
  end  
end
