variable "project_name" { // tên project
  description = "Project name for naming resources"
  type        = string
}

variable "common_tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "block_public_acls" {
  description = "Block public access to S3 bucket"
  type        = bool
  default     = true
}


variable "block_public_policy" {
  description = "Block public access to S3 bucket"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs for S3 bucket"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public buckets for S3 bucket"
  type        = bool
  default     = true
}


variable "enable_versioning" {
  description = "Enable versioning for S3 bucket"
  type        = bool
  default     = true
}

variable "enable_website" {
  description = "Enable static website hosting for S3 bucket"
  type        = bool
  default     = false
}
