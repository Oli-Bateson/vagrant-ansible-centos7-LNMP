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
      default.vm.synced_folder "www", "/vagrant", type: "virtualbox"
      default.vm.synced_folder "ansible", "/ansible", type: "virtualbox"
      default.vm.synced_folder "../bacpac", "/bacpac", type: "virtualbox"
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

    if OS.windows?
    # use shell provisioner to bootstrap - fix yum.repos.d/centos-base file (disable mirror, enable baseurl, change baseurl to vault.centos.org in all cases)
    # then install scl, use scl to install python 2.7, install pip
    #
    # Bootstrap shell script
     config.vm.provision :shell, path: "prebuild-one.sh", privileged: false, name: "prebuild - one"
     config.vm.provision :shell, path: "prebuild-rootsetup.sh", privileged: true, name: "prebuild - root setup"
     config.vm.provision :shell, path: "prebuild-two.sh", privileged: true, name: "prebuild - two"
    # then use ansible_local provisioner
      default.vm.provision "ansible_local" do |ansible|
        ansible.compatibility_mode = "2.0"
        ansible.install_mode = "pip"
        # pip already installed in custom provisioning script prebuild-two.sh so have to override the default install script (shown below)
        # with a dummy version "true" so that the Ansible provisioner does not override our changes
        #ansible.pip_install_cmd = "curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py; sudo python get-pip.py"
        ansible.pip_install_cmd = "true"
        ansible.playbook = "/ansible/install.yml"
        ansible.inventory_path = "/ansible/hosts"
        # Uncomment the next line for increased output from Ansible provisioning, change to "-vvv" for debug level output
        #ansible.verbose = true
        ansible.provisioning_path = "/ansible"
        ansible.extra_vars = {
          windowshost: true
        }

      end
    else
      default.vm.provision "ansible" do |ansible|
        ansible.compatibility_mode = "2.0"
        ansible.playbook = "ansible/install.yml"
        ansible.inventory_path = "ansible/hosts"
        ansible.verbose = true
      end
    end
  end
end
