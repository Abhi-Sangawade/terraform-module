variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default = "ami-01816d07b1128cd2d"
}
variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "terraform"
}
variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}
