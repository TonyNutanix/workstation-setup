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
    description = "UUID of the cluster to build the VMs on and to act as the Source for DR"
    type = string
}

variable "source_cluster_name" {
    description = "Name of the cluster to build the VMs on and to act as the Source for DR"
    type = string
}

variable "destination_cluster" {
    description = "UUID of the cluster to act as the Destination for DR"
    type = string
}

variable "destination_cluster_name" {
    description = "Name of the cluster to act as the Destination for DR"
    type = string
}

variable "prism_central" {
    description = "UUID of the Prism Central, which is used as the Availbility Zone (AZ) URL"
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
