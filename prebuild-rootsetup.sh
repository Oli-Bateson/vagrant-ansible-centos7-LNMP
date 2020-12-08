#!/usr/bin/env bash
PYTHON27_CHECK=$(grep 'python27' ~/.bashrc | awk '{ print $1}')
if [ -z "${PYTHON27_CHECK// }" ]; then
  printf "Set up python2.7 for root user"
  sudo sed -i "\$a source /opt/rh/python27/enable" ~/.bashrc
fi
source ~/.bashrc