#!/usr/bin/env bash
# As root, install pip
curl -s https://bootstrap.pypa.io/2.7/get-pip.py -o get-pip.py
python --version
python get-pip.py