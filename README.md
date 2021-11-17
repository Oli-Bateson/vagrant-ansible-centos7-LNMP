# Centos 6 LNMP Stack
- Centos 6.5
- NginX 1.10.3
- MySQL 5.5/5.7
- PHP 5.5/5.6/7.2/7.3
- Node 11
- NPM 6.7.0
- Memcache 1.4.1

### Run

Edit the `all` file to suit once copied.
Note that, for a VM suitable for bacpac and paywall, the `fastcgi_read_timeout` value in `all.example` has been updated to 300s as per task #142741, but only needs to be this value for bacpac. For paywall it must be reset to 60s after the VM has been built by manually editing the generated nginx configuration file for the paywall host in the VM (generated in `/etc/nginx/conf.d/`), setting the value back to `60`, then reloading the nginx configuration (`nginx -t` to test the change, if ok then run `sudo service nginx reload`) .

For Macs:
```
cp ansible/group_vars/all.example ansible/group_vars/all
vagrant plugin install vagrant-vbguest
vagrant up
```

## Shared directories
Host-VM shared directories have been set up for:
- `/vagrant` (the standard share of the host directory in which the Vagrantfile resides)
- `/ansible` (this repository's `ansible` directory required for Ansible provisioning when on Windows hosts)
- `/bacpac` (this expects to find the `bacpac` codebase in a directory name `bacpac` at the same level as this repository)
- `/paywall` (this expects to find the `paywall` codebase in a directory name `paywall` at the same level as this repository)

The `bacpac` and `paywall` shares can be adjusted as required.

### Add Virtual Hosts
Add a new entry to the `virtual_hosts` dictionary in the `ansible/group_vars/all` file. Set the `host_name` to the virtual host that you would like to use.

Add the following line `192.168.33.35 {host_name}` (where the `{host_name}` is the one from the `all` file) to your hosts file `/etc/hosts`

### Change PHP Versions

Edit `ansible/group_vars/all` with your favourite editor and change the `php_version` variable. The only allowed version
numbers at this time are for PHP 5.5, 5.6, 7.2, 7.4 and Zend PHP 5.6.40 (use `5.5`, `5.6`, `7.2`, `7.4` or `Zend5.6`).
The Zend PHP selection is only for use with bacpac and paywall and requires the use of credentials stored in 1Password.

### Change MySQL Versions
Edit `ansible/group_vars/all` with your favourite editor and change
the `mysql_version` variable. The only allowed version numbers at this time are 5.5 and 5.7.

### Update Dependencies
After changing any ansible settings just run `vagrant up --provision` to propagate the changes to the VM.

### Requirements
- **git**

  Getting started: [wiki](https://en.wikipedia.org/wiki/Git)

- **Vagrant**

  Install vagrant instructions can be found here: [vagrant](https://www.vagrantup.com/downloads.html)

- **VirtualBox**

  Install VirtualBox, instructions can be found here: [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

- **Ansible**

  Install Ansible, instructions can be found here: [Ansible](http://docs.ansible.com/ansible/intro_installation.html#installing-the-control-machine)

### Default Config File Locations Inside The Virtual Machine
**Nginx**
- error log setting : `/var/log/php-fpm/error.log` (This has been configured to remain the same when using ZendPHP)
- nginx configuration : `/etc/nginx/nginx.conf`

**PHP**
- php.ini file is at : `/opt/remi/php56/root/etc/php.ini` (When using ZendPHP, this becomes `/opt/zend/php56zend/root/etc/php.ini`)
- Xdebug executable : `/opt/remi/php56/root/usr/lib64/php/modules/xdebug.so` (When using ZendPHP, this becomes `/opt/zend/php56zend/root/usr/lib64/php/56zend/modules/xdebug.so`)
- xdebug.ini file at : `/opt/remi/php56/root/etc/php.d/15-xdebug.ini` (When using ZendPHP, this becomes `/opt/zend/php56zend/root/etc/php.d/xdebug.ini`)

**CentOS**
- Restart nginx : `sudo service nginx restart`
- To restart PHP-FPM : `sudo service php56-php-fpm restart` (When using ZendPHP, this becomes `sudo service php56zend-php-fpm restart`)

### Running multiple machines
- Duplicate the `"default"` block in `Vagrantfile`
- Rename `"default"` to something else (e.g. `"newVm"`)
- Change both the host port (from `6612`) and the ip (from `192.168.33.35`)
- Access new vm using `vagrant up newVm` and `vagrant ssh newVm`
