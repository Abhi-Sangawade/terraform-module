# Output for VPC module
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id  # Use module output for vpc_id
}

# Output for Subnet module
output "subnet_id" {
  description = "The ID of the subnet"
  value       = module.vpc.subnet_id  # Use module output for subnet_id
}

# Output for EC2 Instance module
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.instance.instance_id  # Use module output for instance_id
}

output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = module.instance.public_ip  # Use module output for public IP
}

output "instance_private_ip" {
  description = "The private IP of the EC2 instance"
  value       = module.instance.private_ip  # Use module output for private IP
}

# Output for Security Group
output "security_group_id" {
  description = "The ID of the security group"
  value       = module.vpc.security_group_id  # Use module output for security_group_id
}
  