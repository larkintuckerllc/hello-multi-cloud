variable aws_asn {
  type = number
}

variable aws_eks_services {
  type = string
}

variable aws_key_name {
  type = string
}

variable aws_private_subnet {
  type = map
}

variable aws_public_subnet {
  type = map
}

variable aws_region {
  type = string
}

variable aws_vpc_cidr_block {
  type = string
}

variable gcp_asn {
  type = number
}

variable gcp_project {
  type = string
}

variable gcp_region {
  type = string
}

variable gcp_subnet {
  type = map
}

variable gcp_zone {
  type = string
}

variable identifier {
  type = string
}