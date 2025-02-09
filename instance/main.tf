resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "<h1>Welcome to My Terraform-Deployed Website 🚀</h1>" | sudo tee /var/www/html/index.html
  EOF

  tags = {
    Name = "TerraformInstance"
  }
}
