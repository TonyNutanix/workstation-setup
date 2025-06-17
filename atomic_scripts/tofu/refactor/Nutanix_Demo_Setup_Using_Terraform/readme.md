# About

Modular approach to building infrastructure for use in customer facing demos.

Most variables should be included in the terraform.tfvars file.  This should be the only file needing modification prior to use.

I have done my best to heavily document all files clearly.

Each demo scenario is fairly self-contained in a module.  Modules can be selected by commenting or uncommenting them in the main.tf file.

There is still some work to be done to meet the above goals.

## Cluster setup

- These scripts are deisgned to work with any HPOC system regardless of location

- Prism Central is required.

- PHX Clusters will currently be a bit quicker as the OS Image being used is located on the PHX file server

- Specific modules in this terraform script require a Prism Central with 2 Clusters attached. Review the module list to determine if 1 or 2 clusters are needed based on the planned module usage.

- Clusters can be any number of nodes (1, 2, 3, 4 or more). 

- Clusters do not need to be in the same location for modules requiring 2 clusters.

- Prequisites can be configured through HPOC runbooks or manually, it doesn't matter as long as they exist and are enabled.

## Prerequisites for everything
This is a consolidated list of the module specific prequisites if all modules will be used.  Refer to individual modules if using a subset of modules.

- Flow or Security Policy Microsegmentation must be enabled by going to Prism Central -> Network & Security -> Security Policies -> Enable. 

- 2 Clusters be registered to the Prism Central 

- Disaster Recovery for the Local AZ must be enabled.  This can be done by going to Prism Central -> Prism Central Settings -> Enable Disaster Recovery -> Enable. 

- Advanced Networking must be enabled. This can be done by going to Prism Central -> Prism Central Settings -> Advanced Networking and selecting Enable.  

### Note
 Advanced Networking requires a Prism Central with Microservice Infrastructure enabled.  Refer to the Prism Central Admin guide for information about this feature before enabling it as the change is significant and the change is beyond the scope of this readme.  The Prism Central must also be the "X-Large" configuration.  Check KB-9887 for guidance. For simplicity it is worth jumping right to the largest recommended PC size of 22 vCPU and 77 GB of RAM.  Be sure to follow the instructions in the KB to run the NCC checks.

## Use
- Visual Studio Code was used to create this code but you can use whatever fits your needs
- Visit the Terraform site for Terraform installation instruactions.  They cover it better than I could.
- Update the terraform.tfvars file with the Nutanix Cluster information
- This isn't a Terraform tutorial, but here are the basic commands needed to use this code
    - terraform init
    - terraform get 
    - terraform plan
    - terraform apply -auto-approve
    - terraform destroy -auto-approve

- All VMs will be created in the cluster identified in by the Index value in main.tf and datasources.tf.  The other cluster will be
  a destination target for Protection Policies, VPCs, etc.
- The UUIDs for each cluster and Prism Central will be output on the screen after "terraform plan".  Compare this with output from "nuclei cluster.list" and 
  fine tune the indexes in main.tf as needed so the variables match the clusters and Prism Central correctly.

## Modules

### vms_in_security_policy
- Create the number of VMs specified and use Flow Microsegmentation to create a security policy for these VMs.
- Prerequisites: Flow or Security Policy Microsegmentation must be enabled.  Works with any number of clusters. Microsegentation can be enabled by going to Prism Central -> Network & Security -> Security Policies -> Enable. 

### vms_in_leap_protection_policy
- Create the number of VMs specified and implement a Leap Protection Policy
- Prerequisites: This module requires 2 Clusters be registered to the Prism Central.  Disaster Recovery for the Local AZ must be enabled.  This can be done by going to Prism Central -> Prism Central Settings -> Enable Disaster Recovery -> Enable. 

### vm_pool_for_any_purpose
- Create the number of VMs specified. These VMs can be used for any purpose.
- Prequisites: None

### vms_in_vpc
- This module is currently under construction
- Create a VPC
- Create the number of VMs specified inside the VPC
- Prequisites: This module requires Advanced Networking be eneabled.  This can be done by going to This can be done by going to Prism Central -> Prism Central Settings -> Advanced Networking and selecting Enable.  Note this feature requires a Prism Central with Microservice Infrastructure enabled.  Refer to the Prism Central Admin guide for information about this feature before enabling it as the change is significant and the change is beyond the scope of this readme.

### Tested Versions

| Nutanix Provider Version | AOS Version | PC Version | Date Tested |
|----------|----------|----------|----------|
| 1.7.0 | 5.20.3 | pc.2022.6 | 9/20/2022 |
| 1.7.0 | 6.5 | pc.2022.6 | 9/21/2022 |
| 1.7.1 | 6.5.1 | pc.2022.6 | 9/28/2022 |
| 1.7.1 | 6.5.1.5 | pc.2022.6.0.1 | 10/17/2022 |

## Known Issues and potential workarounds
- The way Prism Central stores the ordering of clusters and Prism Central is not consistent.  Below are some of the errors caused by this ordering.  Refer to comments in main.tf for information about how to work around the issue.  Usually it is a simple change to an index.

│ Error: subnet with the given name, not found
│
│   with data.nutanix_subnet.Primary,
│   on datasources.tf line 15, in data "nutanix_subnet" "Primary":
│   15: data "nutanix_subnet" "Primary" {
│

│ Error: error waiting for vm (fb4e0f67-9ff1-4631-aa61-b55a5e370e78) to create: error_detail: INVALID_ARGUMENT: Given input is invalid. Referenced cluster 500223c0-4ce7-49a8-b9bd-08fda1c5be3a is not connected, progress_message: create_vm
│
│   with module.vms_in_security_policy.nutanix_virtual_machine.AMH_TF_AUTO_Security_Policy_vm[1],
│   on modules\vms_in_security_policy\main.tf line 16, in resource "nutanix_virtual_machine" "AMH_TF_AUTO_Security_Policy_vm":
│   16: resource "nutanix_virtual_machine" "AMH_TF_AUTO_Security_Policy_vm" {
│
╵
