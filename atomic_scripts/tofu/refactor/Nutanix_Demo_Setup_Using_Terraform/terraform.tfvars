/*
TH: Cluster Variables.  Update this file with the information for the cluster being used
*/

/*
 String to prepend to all entities created by this script for easy identification
 This example is my initials plus TF for Terraform = AMH_TF_

NOTE:  As of 9/21/2022 Terraform does not allow variable interpolation within resource names.  This
 means the Terraform "resource" definitions cannot be named dynamically.  In those cases I use "AMH_TF_AUTO_".  
 This will not cause a problem as those definitions are only used within Terraform and will not appear in Nutanix.
*/
prefix_for_created_entities = "AMH_TF_"
# Prism Central Username
cluster_pc_username = "admin"
# Prism Central Password
cluster_pc_password = "nx2Tech714!"
# Prism Central Port
cluster_pc_port = "9440"
# Prism Central IP or DNS Name
cluster_pc_endpoint = "10.38.193.39"
# Foundation Server IP or DNS Name.  Set to the same value as the Prism Central IP or DNS Name if Foundation is not being used.
# Ommitting this entry causes Terraform to give a warning even if Foundation isn't being used.
cluster_foundation_endpoint = "10.38.193.39"
# Foundation Server Port
cluster_foundation_port = "8000"
# "true" if using an insecure connection.  "false" if using a secure connection.  HPOC will be "true".
cluster_connection_insecure_true_false = "true"
# Connection time out in seconds
cluster_connection_wait_timeout = "30"