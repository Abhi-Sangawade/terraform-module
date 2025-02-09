# Reference security group ID from VPC module
module "vpc" {
  source       = "../vpc" # Make sure this path is correct
  vpc_cidr     = var.vpc_cidr
  subnet_cidr  = var.subnet_cidr
}

# EC2 Instance creation with security group reference
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  # Associate the security group
  security_groups = [module.vpc.http_security_group_id]  # Reference the security group output from vpc module

  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Hello, World" > /var/www/html/index.html
              EOF
}
