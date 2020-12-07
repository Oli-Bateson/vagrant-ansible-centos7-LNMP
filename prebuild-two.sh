#!/usr/bin/env bash
# As root, install pip
curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python --version
python get-pip.py