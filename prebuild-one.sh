#!/usr/bin/env bash
cd /etc/yum.repos.d
if [ ! -f "CentOS-Base.repo.bak" ]; then
  printf "Backing up CentOS-Base.repo file"
  sudo cp CentOS-Base.repo CentOS-Base.repo.bak
fi

printf "Amending CentOS-Base.repo"
sudo sed -i 's|mirrorlist=|#mirrorlist=|g' CentOS-Base.repo
sudo sed -i 's|#baseurl=|baseurl=|g' CentOS-Base.repo
sudo sed -i 's|baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-Base.repo

cd -

printf "Install scl"
sudo yum install -y centos-release-scl

cd /etc/yum.repos.d
if [ ! -f "CentOS-SCLo-scl.repo.bak" ]; then
  printf "Backing up CentOS-SCLo-scl.repo file"
  sudo cp CentOS-SCLo-scl.repo CentOS-SCLo-scl.repo.bak
fi

printf "Amending CentOS-SCLo-scl.repo"
sudo sed -i 's|mirrorlist=|#mirrorlist=|g' CentOS-SCLo-scl.repo
sudo sed -i 's|# baseurl=|baseurl=|g' CentOS-SCLo-scl.repo
sudo sed -i 's|baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-SCLo-scl.repo

if [ ! -f "CentOS-SCLo-scl-rh.repo.bak" ]; then
  printf "Backing up CentOS-SCLo-scl-rh.repo file"
  sudo cp CentOS-SCLo-scl-rh.repo CentOS-SCLo-scl-rh.repo.bak
fi

printf "Amending CentOS-SCLo-scl-rh.repo"
sudo sed -i 's|mirrorlist=|#mirrorlist=|g' CentOS-SCLo-scl-rh.repo
sudo sed -i 's|#baseurl=|baseurl=|g' CentOS-SCLo-scl-rh.repo
sudo sed -i 's|baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' CentOS-SCLo-scl-rh.repo

printf "Install Python 2.7 via scl and set up for vagrant user"
sudo yum install -y python27
PYTHON27_CHECK=$(grep 'python27' ~/.bashrc | awk '{ print $1}')
if [ -z "$PYTHON27_CHECK// " ]; then
  sed -i "\$a\
if [ -f /opt/rh/python27/enable ]; then\
  . /opt/rh/python27/enable\
fi" ~/.bashrc
  source ~/.bashrc
fi