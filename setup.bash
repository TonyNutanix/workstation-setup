#!/bin/bash
########################################
# 04042025: TH - initial script creation
#
########################################

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Update the system
# This currently assumes Rocky Linux
dnf -y check-update
dnf -y update

# Install packages
dnf -y install vim
dnf -y install tmux
dnf -y install python-pip

