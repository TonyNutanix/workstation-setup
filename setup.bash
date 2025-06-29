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
echo INFO: Checking for Rocky Updates
dnf -y check-update
echo INFO: Applying Rocky Updates
dnf -y update

# Install packages
echo INFO: Installing selected packages
dnf -y install vim
dnf -y install tmux
dnf -y install python-pip

# Set up git
echo INFO: Setting up git
source .env
echo INFO: git user.name is being set to $GIT_USER_NAME
echo INFO: git user.email is being set to $GIT_USER_EMAIL
echo INFO: git core.editor is being set to $GIT_CORE_EDITOR
sudo -H -u nutanix git config --global --replace-all user.name "$GIT_USER_NAME"
sudo -H -u nutanix git config --global --replace-all user.email $GIT_USER_EMAIL
sudo -H -u nutanix git config --global --replace-all core.editor $GIT_CORE_EDITOR

# Install OpenTofu
echo INFO: Installing OpenTofu
# Download the installer script:
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
# Alternatively: wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh

# Give it execution permissions:
chmod +x install-opentofu.sh

# Run the installer:
./install-opentofu.sh --install-method rpm

# Remove the installer:
rm -f install-opentofu.sh

# Install Packer
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install packer

# Install Docker
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker nutanix

echo "A reboot may be needed to pick up changes.  Try rebooting if things aren't working as expected after running this script"