#!/usr/bin/env bash
REBUILD_CHECK=$(grep 'python27' ~/.bashrc | awk '{ print $1}')
if [ -z "$REBUILD_CHECK// " ]; then
  printf "Set up python2.7 for root user"
  sudo sed -i "\$a source /opt/rh/python27/enable" ~/.bashrc
fi
source ~/.bashrc