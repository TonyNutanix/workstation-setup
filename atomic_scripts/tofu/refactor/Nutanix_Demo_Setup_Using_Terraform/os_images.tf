/*
TH: List all OS Images that need to be uploaded for use within these scripts.
*/

/*
TH: Define the location for the image to be used for creating the VM.  This image will be uploaded to the cluster by Terraform.
    This example uses the file server in PHX.  
    This same image is typically on the HPOC cluster already, but we are going to upload it again just in case it isn't there.
    The image is used by these moodules:
        vms_in_security_policy
*/
resource "nutanix_image" "AMH_TF_AUTO_CentOS7" {
  name        = "${var.prefix_for_created_entities}CentOS7"
  source_uri  = "http://10.42.194.11/workshop_staging/CentOS7.qcow2"
  description = "${var.prefix_for_created_entities}CentOS7 qcow image"
}