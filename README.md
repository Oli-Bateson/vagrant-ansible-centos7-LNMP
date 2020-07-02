# Centos 6 LNMP Stack
- Centos 6.5
- NginX 1.10.3
- MySQL 5.5/5.7
- PHP 5.5/5.6/7.2/7.3
- Node 11
- NPM 6.7.0
- Memcache 1.4.1

### Run

For Macs:
```
cp ansible/group_vars/all.example ansible/group_vars/all
vagrant plugin install vagrant-vbguest
vagrant up
```

For Windows:
```
cp ansible/group_vars/all.example ansible/group_vars/all
vagrant plugin install vagrant-vbguest
vagrant up (this will fail at the initial Ansible provision step)
(copy generated vagrant user private key into VM and set up SSH config - see below for one-off intervention)
vagrant reload --provision
```
Ansible cannot be installed on Windows, and so it will be installed into the VM by Vagrant and then run from within to provision the VM. However the initial Ansible run fails as the VM needs to be able to provision itself via an SSH connection but cannot connect.
The one-off manual steps to rectify this are as follows:
1. Copy the generated `private_key` from `.vagrant/machines/default/virtualbox` into the VM for vagrant user as `~/.ssh.private_key`
2. SSH into the VM
3. Change directory to `~/.ssh`
4. Create the SSH configuration file `~/.ssh/config` with the following content (using spaces rather than tabs):
    ```
    Host 192.168.33.35
        IdentityFile ~/.ssh/private_key
        User vagrant
    ```
5. Change the access permissions on the `config` and `private_key` files to 0600: `chmod 0600 config private_key`
6. Test that you have set this up by SSHing to the VM from within as the vagrant user `ssh 192.168.33.35` - you'll need to accept the question about connecting to an unknown host; don't forget to `exit` before continuing with provisioning the VM.

### Add Virtual Hosts
Add a new entry to the `virtual_hosts` dictionary in the `ansible/group_vars/all` file. Set the `host_name` to the virtual host that you would like to use.

Add the following line `192.168.33.35 {host_name}` (where the `{host_name}` is the one from the `all` file) to your hosts file `/etc/hosts`

### Change PHP Versions
Edit `ansible/group_vars/all` with your favourite editor and change
the `php_version` variable. 5.5, 5.6 7.1 and 7.2 are the only allowed version numbers at this time.

### Update Dependencies
After changing any ansible settings just run `vagrant up --provision` to propagate the changes to the VM.

### Requirements
- **git**

  Getting started: [wiki](https://en.wikipedia.org/wiki/Git)

- **Vagrant**

  Install vagrant instructions can be found here: [vagrant](https://www.vagrantup.com/downloads.html)

- **VirtualBox**

  Install VirtualBox, instructions can be found here: [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

- **Ansible (Mac only)**

  Install Ansible, instructions can be found here: [Ansible](http://docs.ansible.com/ansible/intro_installation.html#installing-the-control-machine)

### Config File Location Inside The Virtual Machine
**Nginx**
- error log setting : `/var/log/php-fpm/error.log`
- nginx configuration : `/etc/nginx/nginx.conf`

**PHP**
- php.ini file is at : `/opt/remi/php56/root/etc/php.ini`
- Xdebug executable : `/opt/remi/php56/root/usr/lib64/php/modules/xdebug.so`
- xdebug.ini file at : `/opt/remi/php56/root/etc/php.d/15-xdebug.ini`

**CentOS**
- restart nginx : `sudo service nginx restart`
- to restart PHP-FPM : `sudo service php56-php-fpm restart`

### Running multiple machines
- Duplicate the `"default"` block in `Vagrantfile`
- Rename `"default"` to something else (e.g. `"newVm"`)
- Change both the host port (from `6612`) and the ip (from `192.168.33.35`)
- Access new vm using `vagrant up newVm` and `vagrant ssh newVm`
