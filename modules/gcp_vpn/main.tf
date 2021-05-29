locals {
  asn          = 64520
  ip_addresses = [for interface in google_compute_ha_vpn_gateway.this.vpn_interfaces : interface.ip_address]
}

resource "google_compute_router" "this" {
  bgp {
    asn = local.asn
  }
  name     = "${var.identifier}-vpn"
  network  = var.network_id
  region   = var.region
}

resource "google_compute_ha_vpn_gateway" "this" {
  region   = var.region
  name     = var.identifier
  network  = var.network_id
}
