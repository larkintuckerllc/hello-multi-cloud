locals {
  asn          = 64520
  ip_addresses = [for interface in google_compute_ha_vpn_gateway.this.vpn_interfaces : interface.ip_address]
  region       = "us-central1"
}

resource "google_compute_router" "this" {
  bgp {
    asn = local.asn
  }
  name     = "${var.identifier}-vpn"
  network  = var.network_id
  region   = local.region
}

resource "google_compute_ha_vpn_gateway" "this" {
  region   = local.region
  name     = var.identifier
  network  = var.network_id
}
