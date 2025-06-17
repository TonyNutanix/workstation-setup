/*
TH: Create a Protection Policy for the desktop systems created in this module with the following properties:
   - Hourly Snapshot
   - Keep the 2 most recent snapshots on the local and remote cluster
   - Use Crash Consistent snapshots

*/
resource "nutanix_protection_rule" "AMH_TF_AUTO_Protect_Desktops" {

# Name the protection rule and give it a description
name = "${var.prefix_for_created_entities}Protect_Desktops"
description = "${var.prefix_for_created_entities}Terraform created Rule to Protect Desktops"

ordered_availability_zone_list{
   /*TH: Despite the documentation, the availability_zone_url is actually the UUID of Prism Central.  See
       the root main.tf for this project regarding how this UUID is obtained with nuclei.  The AZ URL
       and source cluster (where the VMs currently reside) are specified here.  The source cluster is where
       the main.tf of this module built the VMs.
    */

   availability_zone_url = var.prism_central
   cluster_uuid = var.source_cluster
}

ordered_availability_zone_list{
   /*TH: This is the same as the above section except it specified the destination cluster which currently has 
       none of the VMs located on it.  It will receive the snapshots.
    */

   availability_zone_url = var.prism_central
   cluster_uuid = var.destination_cluster
}

/*
TH: The availablility_zone_connectivity_list is defining a source location, a destination location, a snapshot schedule, and a retention schedule.  
   A definition must exist for both direction.  The first section essentially says "take hourly crash consistent snapshots from the destination cluster and replicate
   them to the source cluster, keep the 2 most recent snapshots on both the source and destination.  

   The second availability_zone_connectivity_list specifies the exact same thing but in the opposite direction - from source to destination.
*/

availability_zone_connectivity_list{
   destination_availability_zone_index = 1
   source_availability_zone_index = 0
   snapshot_schedule_list{
      recovery_point_objective_secs = 3600
      snapshot_type= "CRASH_CONSISTENT"
      local_snapshot_retention_policy {
         num_snapshots = 2
            }
      remote_snapshot_retention_policy {
         num_snapshots = 2
            }
        }
}

availability_zone_connectivity_list{
   destination_availability_zone_index = 0
   source_availability_zone_index = 1
   snapshot_schedule_list{
      recovery_point_objective_secs = 3600
      snapshot_type= "CRASH_CONSISTENT"
      local_snapshot_retention_policy {
         num_snapshots = 2
            }
      remote_snapshot_retention_policy {
         num_snapshots = 2
            }
        }
}

/*
TH: Apply this protection policy to any VMs with the category that was created by the categories.tf - namely "<prefix>Protection_AppType_Desktop"
*/

category_filter {
   params {
      name = data.nutanix_category_key.AppTypeKey.name
      values = [ nutanix_category_value.AMH_TF_AUTO_Protection_AppType_Desktop.value ]
      }
}

}