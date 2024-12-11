output "bastion_host_ip" {
  description = "Public IP address of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "app_server_private_ips" {
  description = "Private IP addresses of the application servers"
  value       = aws_instance.app_server[*].private_ip
}

output "ssh_command_bastion" {
  description = "SSH command to connect to the Bastion Host"
  value       = "ssh -i utc-key.pem ec2-user@${aws_instance.bastion.public_ip}"
}

output "ssh_command_app_server" {
  description = "SSH command to connect to App Servers via Bastion"
  value       = aws_instance.app_server[*].private_ip
}
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
  description = "The public IP address of the Bastion Host"
}
output "alb_dns_name" {
  value = aws_lb.app.dns_name
  description = "The DNS name of the ALB"
}
