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
    default.vm.box = "centos/7"

    config.vbguest.installer_hooks[:before_install] = ["yum install -y epel-release", "sleep 1"]
    config.vbguest.installer_options = { allow_kernel_upgrade: false , enablerepo: true }

    default.vm.network "forwarded_port", guest: 3306, host: 6613
    default.vm.network "forwarded_port", id: "ssh", host: 2225, guest: 22

    default.vm.network :private_network, ip: "192.168.33.35"

    if OS.windows?
      puts 'Building on Windows is no longer supported'
      abort
    end

    # Shared folder
    if OS.mac?
      default.vm.synced_folder "www", "/vagrant", :nfs => true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc' ,'actimeo=2', 'rsize=8192']
      default.vm.synced_folder "../bacpac", "/bacpac", :nfs => true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc', 'actimeo=2', 'rsize=8192']
      default.vm.synced_folder "../paywall", "/paywall", :nfs => true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc', 'actimeo=2', 'rsize=8192']
    end

    default.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000 ]
    end

    default.vm.provision "ansible" do |ansible|
      ansible.compatibility_mode = "2.0"
      ansible.playbook = "ansible/install.yml"
      ansible.inventory_path = "ansible/hosts"
      # Uncomment the next line for increased output from Ansible provisioning, change to "-vvv" for debug level output
      #ansible.verbose = true
    end

  end

     if Vagrant.has_plugin?("vagrant-vbguest")
          config.vbguest.auto_update = false
     end
end
