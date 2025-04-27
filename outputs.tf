#Output.ec2.public ip
output "ec2_public_ip" {
  value       = aws_instance.bustercloud_jupiter_web.public_ip
  description = "public IP of the EC2 instance"
}