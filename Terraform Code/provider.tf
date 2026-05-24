// Provider configuration for AWS
terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
     
}

// Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

// Configure the AWS provider for us-east-1 region (required for CloudFront and WAF)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}