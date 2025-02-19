resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

    associate_public_ip_address = true
  
  tags = {
    Name = "MyTerraform"
  }
  
}

