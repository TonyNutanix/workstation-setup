/*
TH: Variables passed to this module from the root 
*/

variable "vm_subnet" {
    description = "Name of the Subnet to be used for this VM"
    type = string
}

variable "vm_image" {
    description = "Image to use for building the VM OS"
    type = string
}

variable "source_cluster" {
    description = "UUID of the cluster to build the VMs"
    type = string
}

variable "vm_count" {
    description = "Number of VMs to create"
    type = number
}

variable "prefix_for_created_entities"{
    description = "Prefix to prepend to created entities"
    type = string
}
