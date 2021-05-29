output ip_addresses {
  value = local.ip_addresses
}

output router_id {
  value = google_compute_router.this.id
}

output router_name {
  value = google_compute_router.this.name
}

output vpn_gateway_id {
  value = google_compute_ha_vpn_gateway.this.id
}
