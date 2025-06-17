/*
TH: Create a Recovery Plan for the desktop systems created in this module with the following properties:
   - Single Stage
   - Fails over all VMs in the Protection Policy 
*/
# Name the recovery plan and give it a description

resource "nutanix_recovery_plan" "AMH_TF_AUTO_Recovery_Plan_Desktops" {
    name        = "${var.prefix_for_created_entities}Recovery_Plan_Desktops"
    description = "${var.prefix_for_created_entities}Terraform created Recovery Plan for Desktops"

# Define the entities in the stage.
    stage_list {
        stage_work{
            recover_entities{
                entity_info_list{
                    # Use the same category that was used for the protection policy.
                    categories {
                        name = data.nutanix_category_key.AppTypeKey.name
                        value = nutanix_category_value.AMH_TF_AUTO_Protection_AppType_Desktop.value
                    }
                }
            }
        }
    }

    parameters{
        network_mapping_list{
            /*
            TH: Both clusters are in the same Availability Zone so only 1 network_mapping_list is needed.
            */
            availability_zone_network_mapping_list{
                # This block will contain the network info for the source cluster
                # AZ URL is the Prism Central UUID
                availability_zone_url = var.prism_central
                cluster_reference_list {
                    # Source Cluster information
                    kind = "cluster"
                    name = var.source_cluster_name
                    uuid = var.source_cluster
                }

                #The "Primary" network will be used for both recovery and test.  These are the networks that exist on the source cluster.
                recovery_network {
                    name = "Primary"
                }

                test_network {
                    name = "Primary"
                }
            }
        
            availability_zone_network_mapping_list{
                # This block will contain the network info for the destination cluster.  All info is similar to the source cluster block above.
                # AZ URL is the Prism Central UUID
                availability_zone_url = var.prism_central

                cluster_reference_list {
                    kind = "cluster"
                    name = var.destination_cluster_name
                    uuid = var.destination_cluster
                }

                recovery_network {
                    # Use this for AWS based clusters
                    # name = "User VM Network"
                    # Use this for HPOC based clusters
                    name = "Primary"
                }

                test_network {
                    # Use this for AWS based clusters
                    # name = "User VM Network"
                    # Use this for HPOC based clusters
                    name = "Primary"
                }
            }
        }
    }
}
