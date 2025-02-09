output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.main.id
}

output "http_sg_id" {
  value = aws_security_group.http_sg.id
}
