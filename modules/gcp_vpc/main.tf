locals {
  subnet_names = [for subnet in values(google_compute_subnetwork.this) : subnet.name]
}

# VPC

resource "google_compute_network" "this" {
  auto_create_subnetworks         = false
  name                            = var.identifier
}

# SUBNETS

resource "google_compute_subnetwork" "this" {
  for_each      = var.subnet
  ip_cidr_range = each.value["ip_cidr_range"]
  name          = "${var.identifier}-${each.value["region"]}"
  network       = google_compute_network.this.id
  region        = each.value["region"]
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = each.value["ip_cidr_range_pods"]
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = each.value["ip_cidr_range_services"]
  }
}

# GATEWAYS

resource "google_compute_router" "this" {
  for_each = var.subnet
  name     = "${var.identifier}-${each.value["region"]}"
  network  = google_compute_network.this.id
  region   = each.value["region"]
}

resource "google_compute_router_nat" "this" {
  for_each                           = var.subnet
  name                               = "${var.identifier}-${each.value["region"]}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  router                             = google_compute_router.this[each.key].name
  region                             = each.value["region"]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

# FIREWALLS

resource "google_compute_firewall" "allow-icmp-source-private" {
  allow {
    protocol = "icmp"
  }
  name     = "allow-icmp-source-private"
  network  = google_compute_network.this.name
  priority = 1000
  source_ranges = [
    "10.0.0.0/8"
  ]
}