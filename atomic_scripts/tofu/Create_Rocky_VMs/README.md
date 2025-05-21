# Build a Rock VM on Nutanix
This is a quick script to build Rocky Linux VMs on a Nutanix Cluster.

## What it does
1. Creates a new image on the Nutanix Cluster using the specified Rocky qcow which is downloaded directly from the Rocky Linux site
2. Creates the specified number of Rocky Linux VMs on the cluster using the provided cloudinit.yaml to create a user with credentials nutanix:nutanix/4u\
3. Also installs git on the Rocky Linux VMs

## How to use it
1. Edit main.tf and edit the sections with "UPDATE THIS" noted in the commends.
2. Update the cloudinit.yaml if alternate users, passwords, or other items are desired
3. Run 'tofu init'
4. Run 'tofu plan'
5. Run 'tofu apply -auto-approve'
6. To remove everything, run 'tofu destroy -auto-approve'