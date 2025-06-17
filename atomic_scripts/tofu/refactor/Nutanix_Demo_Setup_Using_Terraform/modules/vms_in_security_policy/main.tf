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
TH: This section contains all the details related to the VMs being built for inclusion in the Security Policy.
*/
resource "nutanix_virtual_machine" "AMH_TF_AUTO_Security_Policy_VM" {
  # General Information
  count = var.vm_count
  name                 = "${var.prefix_for_created_entities}Security_Policy_VM_${count.index}"
  description          = "${var.prefix_for_created_entities}Security Policy VM"
  num_vcpus_per_socket = 2
  num_sockets          = 1
  memory_size_mib      = 4096

  # This is telling Terraform which cluster to build the VM on.  This is the cluster identified at the top of this file.
  cluster_uuid = var.vm_cluster

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

    categories {
      name   = data.nutanix_category_key.AppTypeKey.name
      value  = nutanix_category_value.AMH_TF_AUTO_Secure_AppType_Desktop.value
    }

    categories {
      name   = data.nutanix_category_key.AppTierKey.name
      value  = nutanix_category_value.AMH_TF_AUTO_Secure_AppTier_Desktop.value
    }
}