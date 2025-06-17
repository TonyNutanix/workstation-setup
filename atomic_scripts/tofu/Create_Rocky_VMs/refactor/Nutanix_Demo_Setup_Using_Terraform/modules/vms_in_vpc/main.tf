/*
TH: https://stackoverflow.com/questions/65037305/submodule-not-inheriting-providers
    This module is not inheriting the nutanix/nutanix provider from the root so I am using this work around.
*/
terraform {
  required_providers {
      nutanix = {
         source  = "nutanix/nutanix"
      }
   }
}

/*
TH: This section contains all the details related to the VMs being built for inclusion in the VPC.
*/
resource "nutanix_virtual_machine" "AMH_TF_AUTO_Protection_Policy_VM" {
  # General Information
  count = var.vm_count
  name                 = "${var.prefix_for_created_entities}Protection_Policy_VM_${count.index}"
  description          = "${var.prefix_for_created_entities}Proctection Policy VM"
  num_vcpus_per_socket = 2
  num_sockets          = 1
  memory_size_mib      = 4096

  # This is telling Terraform which cluster to build the VM on.  This is the source cluster for the Protection Policy.
  cluster_uuid = var.source_cluster

  # Define the NIC for the VM
  nic_list {
    # This example uses the Primary VLAN in the HPOC
    subnet_uuid = var.vm_subnet
    # DHCP will be used to keep things simple, no further NIC info is needed.
  }

  # What disk/cdrom configuration will this have?
  disk_list {
    # The "Terraform-CentOS7" image refereneced above will be used to build this VM.
    data_source_reference = {
      kind = "image"
      uuid = var.vm_image
    }
    device_properties {
      disk_address = {
        device_index = 0
        adapter_type = "SCSI"
      }
      device_type = "DISK"
    }
  }
}