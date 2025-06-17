/*
TH: Define the categories that will be used for a simple security policy
*/

# Existing AppType
data "nutanix_category_key" "AppTypeKey"{
    name = "AppType"
}

# Add AppType value for Secure_Desktop
resource "nutanix_category_value" "AMH_TF_AUTO_Secure_AppType_Desktop"{
    name = data.nutanix_category_key.AppTypeKey.id
    value = "${var.prefix_for_created_entities}Secure_AppType_Desktop"
}

# Existing AppTier
data "nutanix_category_key" "AppTierKey"{
    name = "AppTier"
}

# Add AppTier value for Secure Desktop
resource "nutanix_category_value" "AMH_TF_AUTO_Secure_AppTier_Desktop"{
    name = data.nutanix_category_key.AppTierKey.id
    value = "${var.prefix_for_created_entities}Secure_AppTier_Desktop"
}