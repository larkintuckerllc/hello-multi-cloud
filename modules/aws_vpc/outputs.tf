output "private_subnet_ids" {
  value = local.private_subnet_ids
}

output "public_subnet_ids" {
  value = local.public_subnet_ids
}

output "subnet_ids" {
  value = local.subnet_ids
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_rt_ids" {
  value = local.private_rt_ids
}

output "public_rt_id" {
  value = aws_route_table.public.id
}
