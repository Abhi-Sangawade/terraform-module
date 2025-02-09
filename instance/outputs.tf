output "instance_id" {
  value = aws_instance.web.id
}
output "public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.my_terraform.public_ip
}