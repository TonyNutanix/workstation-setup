# Build a Rock VM on Nutanix
This is a quick script to build a Rocky Linux VM on a Nutanix Cluster.

## What it does
1. Installs OpenTofu and prerequisites
2. Creates a Rocky Linux VM on the identified Nutanix Cluster

## How to use it
1. Clone this repo (I used Visual Studio Code on Windows)
2. Open a terminal and run the "install_opentofu.ps1" to install OpenTofu
3. Edit main.tf and enter the correct values for the Nutanix cluster
4. Run 'tofu init'
5. Run 'tofu plan'
6. Run 'tofu apply -auto-approve'
7. To remove everything, run 'tofu destroy -auto-approve'