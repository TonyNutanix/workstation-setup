/*
TH: Define the categories that will be used for a simple protection policy
*/

# Existing AppType
data "nutanix_category_key" "AppTypeKey"{
    name = "AppType"
}

# Add AppType value for Protection_Desktop
resource "nutanix_category_value" "AMH_TF_AUTO_Protection_AppType_Desktop"{
    name = data.nutanix_category_key.AppTypeKey.id
    value = "${var.prefix_for_created_entities}Protection_AppType_Desktop"
}