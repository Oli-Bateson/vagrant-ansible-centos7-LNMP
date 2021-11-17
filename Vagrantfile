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

    if OS.windows?
      puts 'Building on Windows is no longer supported'
      abort
    end

    # Need to adjust specific yum.repos.d/*.repo files due to CentOS6 being EOL
    default.vbguest.installer_hooks[:before_install] = [
    "cd /etc/yum.repos.d; if [ ! -f \"CentOS-Base.repo.bak\" ]; then printf \"Backing up CentOS-Base.repo file\"; sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak; fi",
    "printf \"Amending CentOS-Base.repo\"",
    "sudo sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo",
    "sudo sed -i 's|^#baseurl=|baseurl=|g' /etc/yum.repos.d/CentOS-Base.repo",
    "sudo sed -i 's|^baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo",
    "printf \"Install scl\"",
    "sudo yum install -y centos-release-scl",
    "cd /etc/yum.repos.d; if [ ! -f \"CentOS-SCLo-scl.repo.bak\" ]; then printf \"Backing up CentOS-SCLo-scl.repo file\"; sudo cp /etc/yum.repos.d/CentOS-SCLo-scl.repo /etc/yum.repos.d/CentOS-SCLo-scl.repo.bak; fi",
    "printf \"Amending CentOS-SCLo-scl.repo\"",
    "sudo sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-SCLo-scl.repo",
    "sudo sed -i 's|^# baseurl=|baseurl=|g' /etc/yum.repos.d/CentOS-SCLo-scl.repo",
    "sudo sed -i 's|^baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-SCLo-scl.repo",
    "cd /etc/yum.repos.d; if [ ! -f \"CentOS-SCLo-scl-rh.repo.bak\" ]; then printf \"Backing up CentOS-SCLo-scl-rh.repo file\"; sudo cp /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo.bak; fi",
    "printf \"Amending CentOS-SCLo-scl-rh.repo\"",
    "sudo sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo",
    "sudo sed -i 's|^#baseurl=|baseurl=|g' /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo",
    "sudo sed -i 's|^baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo"
    ]

    # Shared folder
    if OS.windows?
      default.vm.synced_folder "www", "/vagrant", type: "virtualbox"
      default.vm.synced_folder "../bacpac", "/bacpac", type: "virtualbox"
      default.vm.synced_folder "../paywall", "/paywall", type: "virtualbox"
    end
    if OS.linux?
      default.vm.synced_folder "www", "/vagrant", :nfs => true
      default.vm.synced_folder "../bacpac", "/bacpac", :nfs => true
      default.vm.synced_folder "../paywall", "/paywall", :nfs => true
    end
    if OS.mac?
      default.vm.synced_folder "www", "/vagrant", :nfs => true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc' ,'actimeo=2']
      default.vm.synced_folder "../bacpac", "/bacpac", :nfs => true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc', 'actimeo=2']
      default.vm.synced_folder "../paywall", "/paywall", :nfs => true, mount_options: ['rw', 'vers=3', 'tcp', 'fsc', 'actimeo=2']
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
end
