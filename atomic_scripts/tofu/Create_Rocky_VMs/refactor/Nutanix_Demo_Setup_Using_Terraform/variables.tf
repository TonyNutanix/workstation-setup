/*
TH: Variable Definitions
*/
variable "cluster_pc_username" {
  type        = string
  description = "Prism Central Username"
}

variable "cluster_pc_password" {
  type        = string
  description = "Prism Central Password"
}

variable "cluster_pc_port" {
  type        = number
  description = "Prism Central Port"
}

variable "cluster_pc_endpoint" {
  type        = string
  description = "Prism Central IP or FQDN"
}

variable "cluster_foundation_endpoint" {
  type        = string
  description = "Foundation Server IP or FQDN"
}

variable "cluster_foundation_port" {
  type        = number
  description = "Foundation Server Port"
}

variable "cluster_connection_insecure_true_false" {
  type        = string
  description = "Prism Central Connection Insecure True or Fales"
}

variable "cluster_connection_wait_timeout" {
  type        = number
  description = "Prism Central Connection Timeout in Seconds"
}

variable "prefix_for_created_entities" {
  type        = string
  description = "Prefix to prepend to all entitites created by this script"
}