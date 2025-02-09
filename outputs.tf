# outputs.tf (root module)

output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = module.instance.instance_id
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = module.vpc.subnet_id
}

output "security_group_id" {
  description = "ID of the created security group"
  value       = module.vpc.http_sg_id
}
