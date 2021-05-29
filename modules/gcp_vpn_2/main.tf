resource "google_compute_external_vpn_gateway" "this" {
  name            = var.identifier
  redundancy_type = "FOUR_IPS_REDUNDANCY"
  interface {
    id         = 0
    ip_address = var.conn0_tunnel1_address
  }
  interface {
    id         = 1
    ip_address = var.conn0_tunnel2_address
  }
  interface {
    id         = 2
    ip_address = var.conn1_tunnel1_address
  }
  interface {
    id         = 3
    ip_address = var.conn1_tunnel2_address
  }
}

# TUNNELS

resource "google_compute_vpn_tunnel" "conn0_tunnel1" {
  name                            = "${var.identifier}-conn0-tunnel1"
  peer_external_gateway           = google_compute_external_vpn_gateway.this.self_link
  peer_external_gateway_interface = 0
  region                          = var.region
  router                          = var.router_id
  shared_secret                   = var.conn0_tunnel1_key
  vpn_gateway                     = var.vpn_gateway_id
  vpn_gateway_interface           = 0
}

resource "google_compute_vpn_tunnel" "conn0_tunnel2" {
  name                            = "${var.identifier}-conn0-tunnel2"
  peer_external_gateway           = google_compute_external_vpn_gateway.this.self_link
  peer_external_gateway_interface = 1
  region                          = var.region
  router                          = var.router_id
  shared_secret                   = var.conn0_tunnel2_key
  vpn_gateway                     = var.vpn_gateway_id
  vpn_gateway_interface           = 0
}

resource "google_compute_vpn_tunnel" "conn1_tunnel1" {
  name                            = "${var.identifier}-conn1-tunnel1"
  peer_external_gateway           = google_compute_external_vpn_gateway.this.self_link
  peer_external_gateway_interface = 2
  region                          = var.region
  router                          = var.router_id
  shared_secret                   = var.conn1_tunnel1_key
  vpn_gateway                     = var.vpn_gateway_id
  vpn_gateway_interface           = 1
}

resource "google_compute_vpn_tunnel" "conn1_tunnel2" {
  name                            = "${var.identifier}-conn1-tunnel2"
  peer_external_gateway           = google_compute_external_vpn_gateway.this.self_link
  peer_external_gateway_interface = 3
  region                          = var.region
  router                          = var.router_id
  shared_secret                   = var.conn1_tunnel2_key
  vpn_gateway                     = var.vpn_gateway_id
  vpn_gateway_interface           = 1
}

# BGP SESSIONS

resource "google_compute_router_interface" "conn0_tunnel1" {
  name       = "${var.identifier}-conn0-tunnel1"
  ip_range   = "${var.conn0_tunnel1_cgw_ip}/30"
  region     = var.region
  router     = var.router_name
  vpn_tunnel = google_compute_vpn_tunnel.conn0_tunnel1.name
}

resource "google_compute_router_peer" "conn0_tunnel1" {
  interface       = google_compute_router_interface.conn0_tunnel1.name
  name            = "${var.identifier}-conn0-tunnel1"
  peer_asn        = var.aws_asn
  peer_ip_address = var.conn0_tunnel1_vgw_ip
  region          = var.region
  router          = var.router_name
}

resource "google_compute_router_interface" "conn0_tunnel2" {
  name       = "${var.identifier}-conn0-tunnel2"
  ip_range   = "${var.conn0_tunnel2_cgw_ip}/30"
  region     = var.region
  router     = var.router_name
  vpn_tunnel = google_compute_vpn_tunnel.conn0_tunnel2.name
}

resource "google_compute_router_peer" "conn0_tunnel2" {
  interface       = google_compute_router_interface.conn0_tunnel2.name
  name            = "${var.identifier}-conn0-tunnel2"
  peer_asn        = var.aws_asn
  peer_ip_address = var.conn0_tunnel2_vgw_ip
  region          = var.region
  router          = var.router_name
}

resource "google_compute_router_interface" "conn1_tunnel1" {
  name       = "${var.identifier}-conn1-tunnel1"
  ip_range   = "${var.conn1_tunnel1_cgw_ip}/30"
  region     = var.region
  router     = var.router_name
  vpn_tunnel = google_compute_vpn_tunnel.conn1_tunnel1.name
}

resource "google_compute_router_peer" "conn1_tunnel1" {
  interface       = google_compute_router_interface.conn1_tunnel1.name
  name            = "${var.identifier}-conn1-tunnel1"
  peer_asn        = var.aws_asn
  peer_ip_address = var.conn1_tunnel1_vgw_ip
  region          = var.region
  router          = var.router_name
}

resource "google_compute_router_interface" "conn1_tunnel2" {
  name       = "${var.identifier}-conn1-tunnel2"
  ip_range   = "${var.conn1_tunnel2_cgw_ip}/30"
  region     = var.region
  router     = var.router_name
  vpn_tunnel = google_compute_vpn_tunnel.conn1_tunnel2.name
}

resource "google_compute_router_peer" "conn1_tunnel2" {
  interface       = google_compute_router_interface.conn1_tunnel2.name
  name            = "${var.identifier}-conn1-tunnel2"
  peer_asn        = var.aws_asn
  peer_ip_address = var.conn1_tunnel2_vgw_ip
  region          = var.region
  router          = var.router_name
}
