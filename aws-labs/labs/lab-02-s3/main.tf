terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = { // aws provider configuration
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = { // random provider configuration
      source = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# -------------------------------------------
# Scenario A — private bucket (lưu trữ thông thường)
# -------------------------------------------
module "s3_private" {
  source = "../../modules/s3" // đường dẫn đến module s3_bucket
  project_name = "${var.project_name}-private" 
  environment = var.environment
  block_public_access = true // chặn truy cập công khai
  enable_versioning = true // bật versioning để lưu trữ các phiên bản của đối tượng
  enable_website = false // không bật tính năng hosting website

  common_tags = {
    Project = var.project_name
    Environment = var.environment
    ManagedBy = "Terraform"
  }
}

# -------------------------------------------
# Scenario B — static website bucket
# -------------------------------------------
module "s3_website" {
  source = "../../modules/s3"
  project_name = "${var.project_name}-web"
  environment = var.environment
  block_public_access = false
  enable_versioning = false
  enable_website = true

  common_tags = {
    Project = var.project_name
    Environment = var.environment
    ManagedBy = "Terraform"
  }
}