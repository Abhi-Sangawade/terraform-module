# vpc/outputs.tf

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.main.id
}

output "http_sg_id" {
  description = "ID of the HTTP security group"
  value       = aws_security_group.http_sg.id
}
