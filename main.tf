terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.15.4"
}

provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = var.gcp_project
}

module "aws_vpc" {
  source         = "./modules/aws_vpc"
  private_subnet = var.aws_private_subnet
  public_subnet  = var.aws_public_subnet
  identifier     = var.identifier
  vpc_cidr_block = var.aws_vpc_cidr_block
}

module "aws_bastion" {
  source     = "./modules/aws_bastion"
  identifier = var.identifier
  key_name   = var.aws_key_name
  subnet_id  = module.aws_vpc.public_subnet_ids[0]
  vpc_id     = module.aws_vpc.vpc_id
}

module "aws_instance" {
  source                    = "./modules/aws_instance"
  bastion_security_group_id = module.aws_bastion.security_group_id
  identifier                = var.identifier
  key_name                  = var.aws_key_name
  subnet_id                 = module.aws_vpc.private_subnet_ids[0]
  vpc_id                    = module.aws_vpc.vpc_id
}

module "aws_eks" {
  source                    = "./modules/aws_eks"
  bastion_security_group_id = module.aws_bastion.security_group_id
  identifier                = var.identifier
  key_name                  = var.aws_key_name
  private_subnet_ids        = module.aws_vpc.private_subnet_ids
  services                  = var.aws_eks_services
  subnet_ids                = module.aws_vpc.subnet_ids
  vpc_id                    = module.aws_vpc.vpc_id
}

module "gcp_vpc" {
  source     = "./modules/gcp_vpc"
  identifier = var.identifier
  subnet     = var.gcp_subnet
}

module "gcp_bastion" {
  source       = "./modules/gcp_bastion"
  identifier   = var.identifier
  network_name = module.gcp_vpc.network_name
  subnet_name  = module.gcp_vpc.subnet_names[0]
  zone         = var.gcp_zone
}

module "gcp_instance" {
  source       = "./modules/gcp_instance"
  identifier   = var.identifier
  network_name = module.gcp_vpc.network_name
  subnet_name  = module.gcp_vpc.subnet_names[0]
  zone         = var.gcp_zone
}

module "gcp_gke" {
  source                 = "./modules/gcp_gke"
  identifier             = var.identifier
  master_ipv4_cidr_block = var.gcp_master_ipv4_cidr_block
  network_name           = module.gcp_vpc.network_name
  region                 = var.gcp_region
  subnet_name            = module.gcp_vpc.subnet_names[0]
}

module "gcp_vpn" {
  source     = "./modules/gcp_vpn"
  gcp_asn    = var.gcp_asn
  identifier = var.identifier
  network_id = module.gcp_vpc.network_id
  region     = var.gcp_region
}

module "aws_vpn" {
  source                 = "./modules/aws_vpn"
  aws_asn                = var.aws_asn
  gcp_asn                = var.gcp_asn
  identifier             = var.identifier
  ip_address_0           = module.gcp_vpn.ip_addresses[0]
  ip_address_1           = module.gcp_vpn.ip_addresses[1]
  private_rt_ids         = module.aws_vpc.private_rt_ids
  public_rt_id           = module.aws_vpc.public_rt_id
  vpc_id                 = module.aws_vpc.vpc_id
}

module "gcp_vpn_2" {
  source                = "./modules/gcp_vpn_2"
  aws_asn               = var.aws_asn
  # CONN0_TUNNEL1
  conn0_tunnel1_address = module.aws_vpn.conn0_tunnel1_address
  conn0_tunnel1_cgw_ip  = module.aws_vpn.conn0_tunnel1_cgw_ip
  conn0_tunnel1_key     = module.aws_vpn.conn0_tunnel1_key
  conn0_tunnel1_vgw_ip  = module.aws_vpn.conn0_tunnel1_vgw_ip
  # CONN0_TUNNEL2
  conn0_tunnel2_address = module.aws_vpn.conn0_tunnel2_address
  conn0_tunnel2_cgw_ip  = module.aws_vpn.conn0_tunnel2_cgw_ip
  conn0_tunnel2_key     = module.aws_vpn.conn0_tunnel2_key
  conn0_tunnel2_vgw_ip  = module.aws_vpn.conn0_tunnel2_vgw_ip
  # CONN1_TUNNEL1
  conn1_tunnel1_address = module.aws_vpn.conn1_tunnel1_address
  conn1_tunnel1_cgw_ip  = module.aws_vpn.conn1_tunnel1_cgw_ip
  conn1_tunnel1_key     = module.aws_vpn.conn1_tunnel1_key
  conn1_tunnel1_vgw_ip  = module.aws_vpn.conn1_tunnel1_vgw_ip
  # CONN1_TUNNEL2
  conn1_tunnel2_address = module.aws_vpn.conn1_tunnel2_address
  conn1_tunnel2_cgw_ip  = module.aws_vpn.conn1_tunnel2_cgw_ip
  conn1_tunnel2_key     = module.aws_vpn.conn1_tunnel2_key
  conn1_tunnel2_vgw_ip  = module.aws_vpn.conn1_tunnel2_vgw_ip
  # END TUNNELS
  identifier            = var.identifier
  region                = var.gcp_region
  router_id             = module.gcp_vpn.router_id
  router_name           = module.gcp_vpn.router_name
  vpn_gateway_id        = module.gcp_vpn.vpn_gateway_id
}
