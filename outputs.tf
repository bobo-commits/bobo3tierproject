#Output.ec2.public ip
output "ec2_public_ip" {
  value       = aws_instance.bustercloud_jupiter_web.public_ip
  description = "public IP of the EC2 instance"
}

#output for App Load Balancer DNS name
output "app_load_balancer_dns_name" {
  value       = aws_lb.application_load_balancer.dns_name
  description = "DNS name of the App Load Balancer"
}