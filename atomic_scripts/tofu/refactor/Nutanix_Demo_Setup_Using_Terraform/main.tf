/*
TH: This grabs a list of all clusters attached to the Prism Central, which includes the Prism Central itself.

Change the "0" to "1" or another number if terraform apply spits out errors saying the Cluster 
    with the UUID is not connected.  I think this happens depending on whether PC or PE comes back
    first or second but I haven't confirmed.

    The same change needs to be made in datasources.tf for the Primary network filter.

    This is what the error looks like:

    Error: error: {
│   "api_version": "3.1",
│   "code": 400,
│   "message_list": [
│     {
│       "message": "Given input is invalid. Referenced cluster ddbde545-2546-4f44-9c8f-c3c722d495cc is not connected",
│       "reason": "INVALID_ARGUMENT"
│     }
│   ],
│   "state": "ERROR"
│ }
│
│   with nutanix_virtual_machine.terraform-vm,
│   on main.tf line 25, in resource "nutanix_virtual_machine" "terraform-vm":
│   25: resource "nutanix_virtual_machine" "terraform-vm" {
│
╵
A list of the connected clusters can be found by doing the following:
- ssh to the Prism Central VM as the 'nutanix' user
- run 'nuclei cluster.list'
- The index may match the output.  Further varification is needed as the list also appears to be alphabetical.
- For example, the fist cluster listed is index 0.
- Prism Central will usually be listed ast "Unnamed"
Adjust tehe below index values as needed if the clusters and PC don't come back in the order of:
  - cluster1
  - cluster2
  - Prism Central
*/
locals {
  cluster1 = data.nutanix_clusters.clusters.entities[0].metadata.uuid
  cluster1_name = data.nutanix_clusters.clusters.entities[0].name
  cluster2 = data.nutanix_clusters.clusters.entities[1].metadata.uuid
  cluster2_name = data.nutanix_clusters.clusters.entities[1].name
  prism_central = data.nutanix_clusters.clusters.entities[2].metadata.uuid
}

/*
TH: Output the values of the variables for cluster1, cluster2 and prism_central.  These will be displayed as the last lines of 
    "terraform plan" and can be used to adjust the above indexes.  Compare the output with the above mentioned "nuclei cluster.list"
    and fine tune as needed.
*/
output "cluster1" {
  value = local.cluster1
}

output "cluster1_name" {
  value = local.cluster1_name
}

output "cluster2" {
  value = local.cluster2
}

output "cluster2_name" {
  value = local.cluster2_name
}

output "prism_central" {
  value = local.prism_central
}

output "vm_subnet" {
  value = data.nutanix_subnet.Primary.name
}


/*
TH: This section contains the "modules" to be included for specific tasks.  Each module is a self-contained sub-directory to carry out the specific 
    creation tasks for the purpose defined in that module.  In other words, each module is an example of a specific Nutanix function that can be 
    used for demos.
*/

module "vms_in_security_policy" {
  source = "./modules/vms_in_security_policy"

  # Use the Primary Subnet
  vm_subnet = data.nutanix_subnet.Primary.id
  # Use the CentOS image created above
  vm_image = nutanix_image.AMH_TF_AUTO_CentOS7.id
  # Place all VMs on the cluster identified above
  vm_cluster = local.cluster1
  # Number of VMs to create
  vm_count = 5
  # Prefix to prepend to created entities
  prefix_for_created_entities = var.prefix_for_created_entities
}

module "vms_in_protection_policy" {
  source = "./modules/vms_in_leap_protection_policy"

  # Use the Primary Subnet
  vm_subnet = data.nutanix_subnet.Primary.id
  # Use the CentOS image created above
  vm_image = nutanix_image.AMH_TF_AUTO_CentOS7.id
  # Source Cluster for Leap AZ
  source_cluster = local.cluster1
  source_cluster_name = local.cluster1_name
  # Destination Cluster for Leap AZ
  destination_cluster = local.cluster2
  destination_cluster_name = local.cluster2_name
  # Prism Central UUID
  prism_central = local.prism_central
  # Number of VMs to create
  vm_count = 5
  # Prefix to prepend to created entities
  prefix_for_created_entities = var.prefix_for_created_entities
}

module "vm_pool_for_any_purpose" {
  source = "./modules/vm_pool_for_any_purpose"

  # Use the Primary Subnet
  vm_subnet = data.nutanix_subnet.Primary.id
  # Use the CentOS image created above
  vm_image = nutanix_image.AMH_TF_AUTO_CentOS7.id
  # Cluster where the VMs will be built
  source_cluster = local.cluster1
  # Number of VMs to create
  vm_count = 5
  # Prefix to prepend to created entities
  prefix_for_created_entities = var.prefix_for_created_entities
}
