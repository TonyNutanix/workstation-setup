/*
TH: Create a Security Policy for the desktop systems created in this module with the following properties:
    - VMs are in the same AppTier but cannot communicate with each other
    - VMs allow inbound traffic on ports 22, 80, 443, 3389, 20009
    - VMs allow outbound traffic on ports 80, 443
    - Deny traffic between VMs in this policy
    - For reference
      - Port 22 for ssh
      - Ports 80 and 443 for http/https
      - Ports 3389 and 20009 for RDP
*/
resource "nutanix_network_security_rule" "AMH_TF_AUTO_Secure_Desktops" {

# Name the security rule and give it a description
name = "${var.prefix_for_created_entities}Secure_Desktops"
description = "${var.prefix_for_created_entities}Terraform created Rule to Secure Desktops"

# Set application rule mode
app_rule_action = "MONITOR"

# Security Rules for Desktops
app_rule_target_group_peer_specification_type = "FILTER"
app_rule_target_group_default_internal_policy = "DENY_ALL"
app_rule_target_group_filter_type = "CATEGORIES_MATCH_ALL"
app_rule_target_group_filter_kind_list = [ "vm" ]

# === Rule will be applyed to ===
app_rule_target_group_filter_params {
   name = data.nutanix_category_key.AppTypeKey.name
   values = [ nutanix_category_value.AMH_TF_AUTO_Secure_AppType_Desktop.value ]
}
app_rule_target_group_filter_params {
   name = data.nutanix_category_key.AppTierKey.name
   values = [ nutanix_category_value.AMH_TF_AUTO_Secure_AppTier_Desktop.value ]
}

 # === Inbound traffic rule ===
app_rule_inbound_allow_list {
   ip_subnet               = "0.0.0.0"
   ip_subnet_prefix_length = "0"
   peer_specification_type = "IP_SUBNET"
   protocol                = "TCP"
      tcp_port_range_list {
      end_port   = 22
      start_port = 22
   }
   tcp_port_range_list {
      end_port   = 80
      start_port = 80
   }
   tcp_port_range_list {
      end_port   = 443
      start_port = 443
   }
      tcp_port_range_list {
      end_port   = 3389
      start_port = 3389
   }
      tcp_port_range_list {
      end_port   = 20009
      start_port = 20009
   }
}

# === Outbound traffic rule ===
app_rule_outbound_allow_list {
    ip_subnet               = "0.0.0.0"
    ip_subnet_prefix_length = "0"
    peer_specification_type = "IP_SUBNET"
    protocol                = "TCP"
    tcp_port_range_list {
      end_port   = 80
      start_port = 80
    }
    tcp_port_range_list {
      end_port   = 443
      start_port = 443
    }
  }
}