/*
TH: This Tofu script wil spin up the number of specified Rocky 9 Linux machines on the specified cluster.


TH: This section tells Tofu which provider and version to be used.

TH: 05202025 Updated to Nutanix Provider 2.2.0
*/

terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "2.2.0"
    }
  }
}

/*
TH: UPDATE THIS section to reflect the proper information for the cluster being used.

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
  password            = "password123"
  port                = 9440
  endpoint            = "10.11.11.11"
  foundation_endpoint = "10.11.11.11"
  foundation_port     = 8000
  insecure            = true
  wait_timeout        = 30
}

/*
TH: UPDATE THIS prefix that will be added to the created entities.  Recommend using <initials>-<purpose>-<date>
*/
locals {
  prefix_for_created_entities = "AMH-SyncRep-05212025"
}

#################################################################################
#
#
#  NOTHING BELOW HERE SHOULD REQUIRE MODIFICATION 
#
#  Exception is for Prism Centrals with Multiple attached clusters.  The Cluster 
#  Index may need to be updated so the correct target cluster is used for 
#  Creation of the of VMs
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

OPTIONAL UPDATE THIS

Change the "0" to "1", "2", or another number if the following error is presented during terraform plan or terraform apply 
or if the entites are craeted on the wrong cluster.

ssh into the PCVM and run "nuclei cluster.list" to get a list of attached cluster names and UUIDs.

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
  cluster1 = data.nutanix_clusters.clusters.entities[1].metadata.uuid
  cluster1_name = data.nutanix_clusters.clusters.entities[1].name
}

/*
TH: Output the values of the variables for cluster1.  These will be displayed as the last lines of 
    "terraform plan" and can be used to adjust the above indexes.  Compare the output with the above mentioned "nuclei cluster.list"
    and fine tune as needed.
*/
output "cluster1" {
  value = local.cluster1
}


/*
TH: Define the location for the image to be used for creating the VM.
*/
resource "nutanix_image" "Automation-Rocky9" {
  name        = "${local.prefix_for_created_entities}-automation-Rocky-9"
  source_uri  = "https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base-9.5-20241118.0.x86_64.qcow2"
  description = "${local.prefix_for_created_entities} automation Rocky 9 Image"
}

/*
TH: This section contains all the details related to the VMs being built.
*/
resource "nutanix_virtual_machine" "Rocky_VM" {
  count                = 5
  name                 = "${local.prefix_for_created_entities}_automation_Rocky_9_${count.index}"
  description          = "${local.prefix_for_created_entities}_automation_Rocky_9${count.index}"
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
      uuid = nutanix_image.Automation-Rocky9.id
     }
/*
05202025 This currently does not work - the VM can only be craeted in the same container as the image
https://github.com/nutanix/terraform-provider-nutanix/issues/223
Workaround: https://portal.nutanix.com/page/documents/details?targetId=AHV-Admin-Guide-v10_0:ahv-vdisk-migration-c.html#nconcept_j4j_y34_pnb__section_wb5_3bd_zcc
Follow the steps to migrate the vDisk after the VM is created or use the vDisk Migration script
    storage_config {
      storage_container_reference {
        kind = "storage_container"
        uuid = "73fd928d-ac23-4e5f-baab-1d0e346f30de"
      }
    }
*/
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
