/*
TH: This section tells Terraform which provider and version to be used.
*/

terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "1.7.1"
    }
  }
}

/*
TH: Updated terraform.tfvars with the connection info.  The variables will be created in variables.tf and obtain the values from terraform.tfvars.

*/
provider "nutanix" {
  username            = var.cluster_pc_username
  password            = var.cluster_pc_password
  port                = var.cluster_pc_port
  endpoint            = var.cluster_pc_endpoint
  foundation_endpoint = var.cluster_foundation_endpoint
  foundation_port     = var.cluster_foundation_port
  insecure            = var.cluster_connection_insecure_true_false
  wait_timeout        = var.cluster_connection_wait_timeout
}