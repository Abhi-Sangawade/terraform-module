# instance/variables.tf

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "The ID of the subnet in which to launch the instance"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to attach to the instance"
  type        = string
}
