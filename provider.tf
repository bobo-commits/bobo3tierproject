# configure AWS Provider
#This file configures the AWS Provider for Terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider and select the appropraite region. 
provider "aws" {
  region = "us-east-2" #change this to your desired region
}

