/*
TH: Create a data source for Nutanix Clusters
*/
data "nutanix_clusters" "clusters" {
}

data "nutanix_subnet" "Primary" {
  subnet_name = "Primary"

  additional_filter {
    name   = "cluster_reference.uuid"
    values = ["${local.cluster1}"]
  }
}