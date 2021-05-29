resource "aws_customer_gateway" "gw0" {
  bgp_asn    = var.gcp_asn
  ip_address = var.ip_address_0
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-0"
  }
  type = "ipsec.1"
}

resource "aws_customer_gateway" "gw1" {
  bgp_asn    = var.gcp_asn
  ip_address = var.ip_address_1
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-1"
  }
  type = "ipsec.1"
}

resource "aws_vpn_gateway" "this" {
  amazon_side_asn = var.aws_asn
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}"
  }
  vpc_id = var.vpc_id
}

resource "aws_vpn_connection" "conn0" {
  customer_gateway_id = aws_customer_gateway.gw0.id
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-0"
  }
  type = "ipsec.1"
  tunnel1_phase1_encryption_algorithms = [
    "AES256"
  ]
  tunnel1_phase1_integrity_algorithms = [
    "SHA2-256"
  ]
  tunnel1_phase1_dh_group_numbers = [
    14
  ]
  tunnel1_phase2_encryption_algorithms = [
    "AES256"
  ]
  tunnel1_phase2_integrity_algorithms = [
    "SHA2-256"
  ]
  tunnel1_phase2_dh_group_numbers = [
    14
  ]
  tunnel2_phase1_encryption_algorithms = [
    "AES256"
  ]
  tunnel2_phase1_integrity_algorithms = [
    "SHA2-256"
  ]
  tunnel2_phase1_dh_group_numbers = [
    14
  ]
  tunnel2_phase2_encryption_algorithms = [
    "AES256"
  ]
  tunnel2_phase2_integrity_algorithms = [
    "SHA2-256"
  ]
  tunnel2_phase2_dh_group_numbers = [
    14
  ]
  vpn_gateway_id = aws_vpn_gateway.this.id
}

resource "aws_vpn_connection" "conn1" {
  customer_gateway_id = aws_customer_gateway.gw1.id
  tags = {
    Infrastructure = var.identifier
    Name           = "${var.identifier}-1"
  }
  type = "ipsec.1"
  tunnel1_phase1_encryption_algorithms = [
    "AES256"
  ]
  tunnel1_phase1_integrity_algorithms = [
    "SHA2-256"
  ]
  tunnel1_phase1_dh_group_numbers = [
    14
  ]
  tunnel1_phase2_encryption_algorithms = [
    "AES256"
  ]
  tunnel1_phase2_integrity_algorithms = [
    "SHA2-256"
  ]
  tunnel1_phase2_dh_group_numbers = [
    14
  ]
  tunnel2_phase1_encryption_algorithms = [
    "AES256"
  ]
  tunnel2_phase1_integrity_algorithms = [
    "SHA2-256"
  ]
  tunnel2_phase1_dh_group_numbers = [
    14
  ]
  tunnel2_phase2_encryption_algorithms = [
    "AES256"
  ]
  tunnel2_phase2_integrity_algorithms = [
    "SHA2-256"
  ]
  tunnel2_phase2_dh_group_numbers = [
    14
  ]
  vpn_gateway_id = aws_vpn_gateway.this.id
}

# ROUTE PROPOGATION

resource "aws_vpn_gateway_route_propagation" "private" {
  count          = length(var.private_rt_ids)
  vpn_gateway_id = aws_vpn_gateway.this.id
  route_table_id = var.private_rt_ids[count.index]
}

resource "aws_vpn_gateway_route_propagation" "public" {
  vpn_gateway_id = aws_vpn_gateway.this.id
  route_table_id = var.public_rt_id
}