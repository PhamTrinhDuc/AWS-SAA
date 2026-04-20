terraform {
  required_version = ">=1.5"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">=5.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}

module "ec2" {
  source = "../../modules/ec2"
  project_name = var.project_name 
  ami_id = var.ami_id
  instance_type = var.instance_type
  public_key_path = var.public_key_path
  allowed_cidr_blocks = var.allowed_cidr_blocks
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}