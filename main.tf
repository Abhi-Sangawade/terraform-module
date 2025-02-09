# main.tf (root module)

provider "aws" {
  region = "us-west-2"
}

# VPC module
module "vpc" {
  source      = "./vpc"
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
}

# Instance module
module "instance" {
  source        = "./instance"
  instance_type = var.instance_type
  ami_id        = var.ami_id
  subnet_id     = module.vpc.subnet_id
  security_group_id = module.vpc.http_sg_id
}

output "instance_id" {
  value = module.instance.instance_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.subnet_id
}

output "security_group_id" {
  value = module.vpc.http_sg_id
}
