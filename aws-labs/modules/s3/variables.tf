variable "project_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "lab"
}

variable "block_public_access" {
  description = "Block all public access to bucket"
  type        = bool
  default     = true
}

variable "enable_versioning" {
  description = "Enable versioning on bucket"
  type        = bool
  default     = false
}

variable "enable_website" {
  description = "Enable static website hosting"
  type        = bool
  default     = false
}

variable "common_tags" {
  type    = map(string)
  default = {}
}