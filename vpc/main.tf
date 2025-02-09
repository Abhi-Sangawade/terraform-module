module "vpc" {
  source      = "./vpc"
  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
}

module "instance" {
  source        = "./instance"
  instance_type = var.instance_type
  ami_id        = var.ami_id
  vpc_cidr      = var.vpc_cidr       # Pass vpc_cidr
  subnet_cidr   = var.subnet_cidr    # Pass subnet_cidr
  subnet_id     = module.vpc.subnet_id  # Reference the output from the VPC module
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "main-subnet"
  }
}

resource "aws_security_group" "http_sg" {
  name        = "http-security-group"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

