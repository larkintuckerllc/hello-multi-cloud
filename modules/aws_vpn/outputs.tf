# CONN0_TUNNEL1

output conn0_tunnel1_address {
  value = aws_vpn_connection.conn0.tunnel1_address
}

output conn0_tunnel1_cgw_ip {
  value = aws_vpn_connection.conn0.tunnel1_cgw_inside_address
}

output conn0_tunnel1_key {
  value = aws_vpn_connection.conn0.tunnel1_preshared_key
}

output conn0_tunnel1_vgw_ip {
  value = aws_vpn_connection.conn0.tunnel1_vgw_inside_address
}

# CONN0_TUNNEL2

output conn0_tunnel2_address {
  value = aws_vpn_connection.conn0.tunnel2_address
}

output conn0_tunnel2_cgw_ip {
  value = aws_vpn_connection.conn0.tunnel2_cgw_inside_address
}

output conn0_tunnel2_key {
  value = aws_vpn_connection.conn0.tunnel2_preshared_key
}

output conn0_tunnel2_vgw_ip {
  value = aws_vpn_connection.conn0.tunnel2_vgw_inside_address
}

# CONN1_TUNNEL1

output conn1_tunnel1_address {
  value = aws_vpn_connection.conn1.tunnel1_address
}

output conn1_tunnel1_cgw_ip {
  value = aws_vpn_connection.conn1.tunnel1_cgw_inside_address
}

output conn1_tunnel1_key {
  value = aws_vpn_connection.conn1.tunnel1_preshared_key
}

output conn1_tunnel1_vgw_ip {
  value = aws_vpn_connection.conn1.tunnel1_vgw_inside_address
}

# CONN1_TUNNEL2

output conn1_tunnel2_address {
  value = aws_vpn_connection.conn1.tunnel2_address
}

output conn1_tunnel2_cgw_ip {
  value = aws_vpn_connection.conn1.tunnel2_cgw_inside_address
}

output conn1_tunnel2_key {
  value = aws_vpn_connection.conn1.tunnel2_preshared_key
}

output conn1_tunnel2_vgw_ip {
  value = aws_vpn_connection.conn1.tunnel2_vgw_inside_address
}