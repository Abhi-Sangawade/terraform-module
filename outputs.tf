output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "instance_id" {
  description = "Instance ID"
  value       = module.instance.instance_id
}
