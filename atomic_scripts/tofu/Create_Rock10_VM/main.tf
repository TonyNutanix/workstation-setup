/*
TH: This section tells Terraform which provider and version to be used.
*/

terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "2.0.0"
    }
  }
}

/*
TH: Update this section to reflect the proper information for the cluster being used.

username: Prism Central Username
password: Prism Central Password
port: Should not need to be changed
endpoint: IP address for the Prism Central (this does not work if pointed to Prism Element)
foundation_endpoint: Set it to the IP address of Prism Central. Foundation is not used in this example.  It is included simply to prevent Terraform from presenting a warning which may cause confusion
fountation_port: No change needed.  Same as the foundation_endpoint, this is simply populated to prevent a warning.
insecure: No change needed.
wait_timeout: No change needed.

*/
provider "nutanix" {
  username            = "admin"
  password            = "password"
  port                = 9440
  endpoint            = "10.11.22.33"
  foundation_endpoint = "10.11.22.33"
  foundation_port     = 8000
  insecure            = true
  wait_timeout        = 30
}

/*
TH: This is the prefix that will be added to the created VMs.  Replace this with your initials.
*/
locals {
  prefix_for_created_entities = "AMH_02162026"
}

#################################################################################
#
#
#  NOTHING BELOW HERE SHOULD REQUIRE MODIFICATION
#
#
#################################################################################

/*
TH: Create a data source for Nutanix Clusters
*/
data "nutanix_clusters" "clusters" {
}

/*
TH: Create a data source for the "Primary" subnet
*/
data "nutanix_subnet" "Primary" {
  subnet_name = "Primary"
}

/*
TH: This grabs a list of all clusters attached to the Prism Central, which includes the Prism Central itself.

Change the "0" to "1" if the following error is presented during terraform plan or terraform apply 

    Error: error: {
   "api_version": "3.1",
   "code": 400,
   "message_list": [
     {
       "message": "Given input is invalid. Referenced cluster ddbde545-2546-4f44-9c8f-c3c722d495cc is not connected",
       "reason": "INVALID_ARGUMENT"
     }
*/
locals {
  cluster1 = data.nutanix_clusters.clusters.entities[0].metadata.uuid
}

/*
TH: Define the location for the image to be used for creating the VM.
*/
resource "nutanix_image" "Automation-Rocky10" {
  name        = "${local.prefix_for_created_entities}-automation-Rocky-10"
  #source_uri  = "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
  source_uri = "https://dl.rockylinux.org/pub/rocky/10/images/x86_64/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"
  description = "${local.prefix_for_created_entities} automation Rocky 10 Image"
}

/*
TH: This section contains all the details related to the VMs being built.
*/
resource "nutanix_virtual_machine" "Rocky_VM" {
  count                = 1
  name                 = "${local.prefix_for_created_entities}_automation_Rocky_10_${count.index}"
  description          = "${local.prefix_for_created_entities}_automation_Rocky_10${count.index}"
  num_vcpus_per_socket = 2
  num_sockets          = 1
  memory_size_mib      = 4096
  cluster_uuid         = local.cluster1
  nic_list {
    subnet_uuid = data.nutanix_subnet.Primary.id
  }
  disk_list {
    data_source_reference = {
      kind = "image"
      uuid = nutanix_image.Automation-Rocky10.id
    }
    device_properties {
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }
      device_type = "DISK"
    }
  }
  guest_customization_cloud_init_user_data = filebase64("./cloudinit.yaml")
}