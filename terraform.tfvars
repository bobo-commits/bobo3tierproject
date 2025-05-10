# This file contains the variable values for the Terraform configuration.
# It is used to set the values for the variables defined in the variables.tf file.
vpc_cidr                     = "10.0.0.0/16"
public_subnet-az1a_cidr      = "10.0.1.0/24"
public_subnet-az1b_cidr      = "10.0.2.0/24"
private_app_subnet-az1a_cidr = "10.0.3.0/24"
private_app_subnet-az1b_cidr = "10.0.4.0/24"
private_db_subnet-az1a_cidr  = "10.0.5.0/24"
private_db_subnet-az1b_cidr  = "10.0.6.0/24"
aws_region                   = "us-west-2"
instance_type                = "t2.micro" # Optional default
ec2_ami_id                   = "ami-04985531f48a27ae7"