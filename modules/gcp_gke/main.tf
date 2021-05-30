resource "google_container_cluster" "this" {
  initial_node_count = 1
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  location                 = var.region
  name                     = var.identifier
  network                  = var.network_name
  remove_default_node_pool = true
  resource_labels = {
    infrastructure = var.identifier
  }
  subnetwork = var.subnet_name
}

resource "google_container_node_pool" "this" {
  cluster    = google_container_cluster.this.name
  location   = var.region
  name       = var.identifier
  node_count = 3
}
