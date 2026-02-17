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
echo "$(tput bold)$(tput setaf 4)########## INFO: Checking for Rocky Updates ##########$(tput sgr0)"
dnf -y check-update
echo "$(tput bold)$(tput setaf 4)########## INFO: Applying Rocky Updates ##########$(tput sgr0)"
dnf -y update
# This is required for Docker on Rocky10
dnf install -y kernel-modules-extra
modprobe xt_addrtype

# Install packages
echo "$(tput bold)$(tput setaf 4)########## INFO: Installing selected packages ##########$(tput sgr0)"
dnf -y install vim
dnf -y install tmux
dnf -y install net-tools
dnf -y install python-pip

# Set up git
echo "$(tput bold)$(tput setaf 4)########## INFO: Setting up git ##########$(tput sgr0)"
source .env
echo INFO: git user.name is being set to $GIT_USER_NAME
echo INFO: git user.email is being set to $GIT_USER_EMAIL
echo INFO: git core.editor is being set to $GIT_CORE_EDITOR
sudo -H -u nutanix git config --global --replace-all user.name "$GIT_USER_NAME"
sudo -H -u nutanix git config --global --replace-all user.email $GIT_USER_EMAIL
sudo -H -u nutanix git config --global --replace-all core.editor $GIT_CORE_EDITOR

# Install OpenTofu
echo "$(tput bold)$(tput setaf 4)########## INFO: Installing OpenTofu ##########$(tput sgr0)"
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
echo "$(tput bold)$(tput setaf 4)########## INFO: Installing Packer ##########$(tput sgr0)"
yum install -y yum-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
yum -y install packer

# Install Docker
echo "$(tput bold)$(tput setaf 4)########## INFO: Installing Docker ##########$(tput sgr0)"
# sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo # This worked on Rocky9
# sudo dnf -y install docker-ce docker-ce-cli containerd.io # This worked on Rocky9
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io 
systemctl start docker
systemctl enable docker
usermod -aG docker nutanix

# Install VS Code Web Server and run it as the nutanix user
echo "$(tput bold)$(tput setaf 4)########## INFO: Installing VS Code Server ##########$(tput sgr0)"
dnf install -y curl nano
curl -fsSL https://code-server.dev/install.sh | sh
systemctl enable --now code-server@nutanix
# Need to wait for service to start so the default config.yaml gets created
sleep 60
sed -i 's/127\.0\.0\.1/0.0.0.0/g' /home/nutanix/.config/code-server/config.yaml

# Install Ansible
echo "$(tput bold)$(tput setaf 4)########## INFO: Installing Ansible ##########$(tput sgr0)"
# sudo dnf install ansible-core -y # Need 2.16 or higher, this install an older version
sudo -u nutanix -i pip install "ansible-core>=2.16"
sudo -u nutanix -i pip install requests urllib3 --user #this might fail and can be run with a non-root account
sudo -u nutanix -i ansible-galaxy collection install nutanix.ncp


echo "$(tput bold)$(tput setaf 4)########## INFO: Installation Complete ##########$(tput sgr0)"
echo "$(tput bold)$(tput setaf 1)Here are important things to know!$(tput sgr0)"
echo "$(tput bold)$(tput setaf 2)Docker will fail to start during this installation process. It works after reboot.$(tput sgr0)"
echo "$(tput bold)$(tput setaf 2)This is the password for VS Code on port 8080: $(tput sgr0)"
sudo cat /home/nutanix/.config/code-server/config.yaml | grep -i "password:"
echo "$(tput bold)$(tput setaf 2)VS Code Server will not have the .gitconfig setup for root. Open a termainal in VS Code Server and run these two commands:$(tput sgr0)"
echo "$(tput bold)$(tput setaf 2)git config --global user.name \"<username>\"$(tput sgr0)"
echo "$(tput bold)$(tput setaf 2)git config --global user.email \"<quoted email address>\"$(tput sgr0)"
echo "$(tput bold)$(tput setaf 2)A reboot is required at this point! Reboot and enjoy!$(tput sgr0)"