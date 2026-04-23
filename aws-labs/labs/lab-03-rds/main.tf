terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -------------------------------------------
# Dùng default VPC và subnets có sẵn để lab
# không cần tạo VPC mới
# -------------------------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# -------------------------------------------
# Aurora module
# -------------------------------------------
module "aurora" {
  source = "../../modules/rds"

  project_name  = var.project_name
  # environment   = var.environment
  vpc_id        = data.aws_vpc.default.id
  subnet_ids    = data.aws_subnets.default.ids

  # Cho phép kết nối từ local machine để test
  allowed_cidr_blocks = var.allowed_cidr_blocks

  database_name   = var.database_name
  master_username = var.master_username
  master_password = var.master_password

  instance_class  = var.instance_class
  enable_reader   = var.enable_reader

  # Lab thì để public để connect từ máy local
  publicly_accessible = true

  backup_retention_days = 1

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}