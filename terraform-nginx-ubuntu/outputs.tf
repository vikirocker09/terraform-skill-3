output "instance_public_ip" {
  description = "Public IP address of the Nginx EC2 instance"
  value       = aws_instance.nginx_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the Nginx EC2 instance"
  value       = aws_instance.nginx_server.public_dns
}

output "nginx_url" {
  description = "URL to view the deployed Nginx page"
  value       = "http://${aws_instance.nginx_server.public_ip}"
}

output "security_group_id" {
  description = "ID of the security group attached to the instance"
  value       = aws_security_group.nginx_sg.id
}
