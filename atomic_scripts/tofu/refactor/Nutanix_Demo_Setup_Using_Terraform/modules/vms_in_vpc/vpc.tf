/*
TH: Create a VPC with the following properties:
- 

*/

/* 
Create the VPC
*/

resource "nutanix_vpc" "AMH_TF_AUTO_VPC" {
  
  # Name of the VPC
  name = "${var.prefix_for_created_entities}VPC"
  
}