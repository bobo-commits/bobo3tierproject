#create a variable for the VPC CIDR block
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

#create a variable for the public subnet az1a CIDR block
variable "public_subnet-az1a_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR block for the public subnet az1a"
}

#create a variable for the public subnet az1b CIDR block
variable "public_subnet-az1b_cidr" {
  type        = string
  default     = "10.0.2.0/24"
  description = "CIDR block for the public subnet az1b"
}

#create a variable for the private app subnet az1a CIDR block
variable "private_app_subnet-az1a_cidr" {
  type        = string
  default     = "10.0.3.0/24"
  description = "CIDR block for the private app subnet az1a"
}

#create a variable for the private app subnet az1b CIDR block
variable "private_app_subnet-az1b_cidr" {
  type        = string
  default     = "10.0.4.0/24"
  description = "CIDR block for the private app subnet az1b"
}

#create a variable for the private db subnet az1a CIDR block
variable "private_db_subnet-az1a_cidr" {
  type        = string
  default     = "10.0.5.0/24"
  description = "CIDR block for the private db subnet az1a"
}

#create a variable for the private db subnet az1b CIDR block
variable "private_db_subnet-az1b_cidr" {
  type        = string
  default     = "10.0.6.0/24"
  description = "CIDR block for the private db subnet az1b"
}

#create a variable for domain_name
variable "domain_name" {
  type        = string
  default     = "bustercloud.com"
  description = "Domain name for the VPC"
}

variable "ec2_ami_id" {
  type        = string
  default     = "ami-04985531f48a27ae7"
  description = "AMI ID for the EC2 instance"
}