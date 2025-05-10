#Create VPC
resource "aws_vpc" "bustercloud_project_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "bustercloud_project_vpc"
  }
}

#Create an AWS Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "bustercloud_project_igw" {
  vpc_id = aws_vpc.bustercloud_project_vpc.id

  tags = {
    Name = "bustercloud_project_igw"
  }
}

#This resource creates a public subnet in the VPC
#Ensure naming the subnet to public_subnet-az1a to match the naming convention.
resource "aws_subnet" "bustercloud_project_public_subnet-az1a" {
  vpc_id                  = aws_vpc.bustercloud_project_vpc.id
  cidr_block              = var.public_subnet-az1a_cidr
  availability_zone       = "us-east-2a" #change to your availability zone
  map_public_ip_on_launch = true

  depends_on = [aws_vpc.bustercloud_project_vpc,
    aws_internet_gateway.bustercloud_project_igw
  ]

  tags = {
    Name = "bustercloud_project_public_subnet-az1a"
  }
}

#This resource creates a public subnet in  AZ 1b in the VPC
#Ensure naming the subnet to public_subnet-az1b to match the naming convention.
resource "aws_subnet" "bustercloud_project_public_subnet-az1b" {
  vpc_id                  = aws_vpc.bustercloud_project_vpc.id
  cidr_block              = var.public_subnet-az1b_cidr
  availability_zone       = "us-east-2b" #change to your availability zone
  map_public_ip_on_launch = true

  depends_on = [aws_vpc.bustercloud_project_vpc,
    aws_internet_gateway.bustercloud_project_igw
  ]

  tags = {
    Name = "bustercloud_project_public_subnet-az1b"
  }
}
#create a Private app subnet in AZ 1a in the VPC
#Ensure naming the subnet to Private_app_subnet-az1a to match the naming convention.
resource "aws_subnet" "bustercloud_project_private_app_subnet-az1a" {
  vpc_id                  = aws_vpc.bustercloud_project_vpc.id
  cidr_block              = var.private_app_subnet-az1a_cidr
  availability_zone       = "us-east-2a" #change to your availability zone
  map_public_ip_on_launch = false        #set to false for private subnet (private subnte should not have public IPs assigned to instances by Default.)

  depends_on = [aws_vpc.bustercloud_project_vpc,
    aws_internet_gateway.bustercloud_project_igw
  ]

  tags = {
    Name = "bustercloud_project_private_app_subnet-az1a"
  }
}

#create a Private app subnet in AZ 1b in the VPC
#Ensure naming the subnet to Private_app_subnet-az1b to match the naming convention.
resource "aws_subnet" "bustercloud_project_private_app_subnet-az1b" {
  vpc_id                  = aws_vpc.bustercloud_project_vpc.id
  cidr_block              = var.private_app_subnet-az1b_cidr
  availability_zone       = "us-east-2b" #change to your availability zone
  map_public_ip_on_launch = false

  depends_on = [aws_vpc.bustercloud_project_vpc,
    aws_internet_gateway.bustercloud_project_igw
  ]

  tags = {
    Name = "bustercloud_project_private_app_subnet-az1b"
  }
}

#create a Private DB subnet in AZ 1a in the VPC
#Ensure naming the subnet to Private_DB_subnet-az1a to match the naming convention.
resource "aws_subnet" "bustercloud_project_private_db_subnet-az1a" {
  vpc_id                  = aws_vpc.bustercloud_project_vpc.id
  cidr_block              = var.private_db_subnet-az1a_cidr
  availability_zone       = "us-east-2a" #change to your availability zone
  map_public_ip_on_launch = false

  depends_on = [aws_vpc.bustercloud_project_vpc,
    aws_internet_gateway.bustercloud_project_igw
  ]

  tags = {
    Name = "bustercloud_project_private_db_subnet-az1a"
  }
}

#create a Private DB subnet in AZ 1b in the VPC
#Ensure naming the subnet to Private_DB_subnet-az1b to match the naming convention.
resource "aws_subnet" "bustercloud_project_private_db_subnet-az1b" {
  vpc_id                  = aws_vpc.bustercloud_project_vpc.id
  cidr_block              = var.private_db_subnet-az1b_cidr
  availability_zone       = "us-east-2b" #change to your availability zone
  map_public_ip_on_launch = false

  depends_on = [aws_vpc.bustercloud_project_vpc,
    aws_internet_gateway.bustercloud_project_igw
  ]

  tags = {
    Name = "bustercloud_project_private_db_subnet-az1a"
  }
}
#Create AWS EIP for NAT Gateway in the public subnet of AZ 1a.
#Ensure naming the EIP to nat_gateway_eip-az1a to match the naming convention.
resource "aws_eip" "bustercloud_nat_gateway_eip-az1a" {
  domain = "vpc"


  tags = {
    Name = "bustercloud_project_nat_gateway_eip-az1a"
  }
}

#create a NAT gateway in the Public subnet of AZ 1a
#Ensure naming the NAT Gateway to nat_gateway az1a to match the naming convention.
resource "aws_nat_gateway" "bustercloud_nat_gateway-az1a" {
  allocation_id = aws_eip.bustercloud_nat_gateway_eip-az1a.id
  subnet_id     = aws_subnet.bustercloud_project_public_subnet-az1a.id

  tags = {
    Name = "bustercloud_nat_gateway-az1a"
  }

  depends_on = [aws_internet_gateway.bustercloud_project_igw,
  aws_subnet.bustercloud_project_public_subnet-az1a]
}

#Create a public route table for the public subnets.
#Ensure you name the route table to public_route_table-az1a to match thr naming convention.
resource "aws_route_table" "bustercloud_public_rt" {
  vpc_id = aws_vpc.bustercloud_project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bustercloud_project_igw.id
  }

  tags = {
    Name = "bustercloud_public_rt"
  }
}
# associate the public route table with the public subnets in AZ 1a and AZ 1b.
resource "aws_route_table_association" "public_subnet_association_az1a" {
  subnet_id      = aws_subnet.bustercloud_project_public_subnet-az1a.id
  route_table_id = aws_route_table.bustercloud_public_rt.id
}

# associate the public route table with the public subnets in AZ 1b.
resource "aws_route_table_association" "public_subnet_association_az1b" {
  subnet_id      = aws_subnet.bustercloud_project_public_subnet-az1b.id
  route_table_id = aws_route_table.bustercloud_public_rt.id
}

#create a Private Route Table for the private app subents
#Ensure you name the route table to private_route_table-az1a to match the naming convention.
resource "aws_route_table" "bustercloud_private_app_rt" {
  vpc_id = aws_vpc.bustercloud_project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.bustercloud_nat_gateway-az1a.id
  }

  tags = {
    Name = "Route Table fpr Private app Subnets"
  }
}

#create a Private Route Table for the private DB subents
#Ensure you name the route table to private_route_table-az1a to match thr naming convention.
resource "aws_route_table" "bustercloud_private_db_rt" {
  vpc_id = aws_vpc.bustercloud_project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.bustercloud_nat_gateway-az1a.id
  }

  tags = {
    Name = "Route Table fpr Private db Subnets"
  }
}

# associate the private route table with the private app subnets in AZ 1a.
resource "aws_route_table_association" "private_app_subnet_association_az1a" {
  subnet_id      = aws_subnet.bustercloud_project_private_app_subnet-az1a.id
  route_table_id = aws_route_table.bustercloud_private_app_rt.id
}
# associate the private route table with the private database subnets in AZ 1a
resource "aws_route_table_association" "private_db_subnet_association_az1a" {
  subnet_id      = aws_subnet.bustercloud_project_private_db_subnet-az1a.id
  route_table_id = aws_route_table.bustercloud_private_db_rt.id
}

# associate the private route table with the private app subnets in AZ 1b.
resource "aws_route_table_association" "private_app_subnet_association_az1b" {
  subnet_id      = aws_subnet.bustercloud_project_private_app_subnet-az1b.id
  route_table_id = aws_route_table.bustercloud_private_app_rt.id
}

# associate the private route table with the private database subnets in AZ 1b
resource "aws_route_table_association" "private_db_subnet_association_az1b" {
  subnet_id      = aws_subnet.bustercloud_project_private_db_subnet-az1b.id
  route_table_id = aws_route_table.bustercloud_private_db_rt.id
} 