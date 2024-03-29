#! /bin/bash

# exit if a command fails
set -e

apt-get update
apt-get install -y build-essential
apt-get install -y software-properties-common
apt-get install -y octave
apt-get remove -y software-properties-common
apt-get install -y liboctave-dev
apt-get install -y octave-statistics

# specific packages required by the code.
apt-get install -y fig2dev

# cleanup package manager
apt-get autoclean && apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
