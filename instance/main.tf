module "vpc" {
  source       = "../vpc"
  vpc_cidr     = var.vpc_cidr
  subnet_cidr  = var.subnet_cidr
  vpc_id       = aws_vpc.main.id  # Pass the vpc_id output from aws_vpc resource
}


resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.subnet_id

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
