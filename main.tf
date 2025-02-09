provider "aws" {
  region = var.aws_region
}

# Call VPC Module
module "vpc" {
  source       = "./vpc"
  vpc_cidr     = var.vpc_cidr
  subnet_cidr  = var.subnet_cidr
}

# Call Instance Module
module "instance" {
  source        = "./instance"
  instance_type = var.instance_type
  ami_id        = var.ami_id
  subnet_id     = module.vpc.subnet_id  
  
}
