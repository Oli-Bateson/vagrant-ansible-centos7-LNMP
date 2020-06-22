# -*- mode: ruby -*-
# vi: set ft=ruby :

#Check OS host version
module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end
  def OS.mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end
  def OS.unix?
    !OS.windows?
  end
  def OS.linux?
    OS.unix? and not OS.mac?
  end
end

Vagrant.configure("2") do |config|
  config.vm.define "default" do |default|
    default.vm.box = "centos/6"

    default.vm.network "forwarded_port", guest: 3306, host: 6612

    default.vm.network :private_network, ip: "192.168.33.35"
    # Shared folder
    if OS.windows?
      default.vm.synced_folder "www", "/vagrant"
      default.vm.synced_folder "ansible", "/ansible"
      default.vm.synced_folder "../bacpac", "/bacpac"
    end
    if OS.linux?
      default.vm.synced_folder "www", "/vagrant", :nfs => true
      default.vm.synced_folder "ansible", "/ansible", :nfs => true
      default.vm.synced_folder "../bacpac", "/bacpac", :nfs => true
    end
    if OS.mac?
      default.vm.synced_folder "www", "/vagrant", :nfs => true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc' ,'actimeo=2']
      default.vm.synced_folder "ansible", "/ansible", :nfs => true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc', 'actimeo=2']
      default.vm.synced_folder "../bacpac", "/bacpac", :nfs => true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc', 'actimeo=2']
    end


    default.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000 ]
    end

    default.vm.provision "ansible_local" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "/ansible/install.yml"
      ansible.inventory_path = "/ansible/hosts"
      ansible.verbose = true
      ansible.provisioning_path = "/ansible"
    end
  end
end
