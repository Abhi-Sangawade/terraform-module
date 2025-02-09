resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_security_group" "http_sg" {
  name        = "http-security-group"
  description = "Allow HTTP inbound traffic"
  

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


resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr
  map_public_ip_on_launch = true
}
