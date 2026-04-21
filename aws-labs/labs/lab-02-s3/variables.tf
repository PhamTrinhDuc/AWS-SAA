variable aws_region {
  type        = string
  default     = "ap-southeast-1"
  description = "The AWS region where the S3 bucket will be created."
}

variable project_name {
  type        = string
  default     = "my-s3-bucket"
  description = "The name of the project, used as a prefix for the S3 bucket name."
}

variable environment {
  type        = string
  default     = "dev"
  description = "The environment for the S3 bucket (e.g., dev, staging, prod)."
}