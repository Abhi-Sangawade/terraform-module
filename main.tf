
provider "aws" {
  region = "us-east-1"
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




