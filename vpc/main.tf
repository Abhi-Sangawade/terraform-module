# Define security group in vpc module
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

# Output the security group ID
output "http_security_group_id" {
  value = aws_security_group.http_sg.id
}
