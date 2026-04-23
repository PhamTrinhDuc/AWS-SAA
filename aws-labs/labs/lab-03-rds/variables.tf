variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "project_name" {
  type    = string
  default = "saa-lab-03"
}

variable "environment" {
  type    = string
  default = "lab"
}

variable "database_name" {
  type    = string
  default = "appdb"
}

variable "master_username" {
  type    = string
  default = "admin"
}

variable "master_password" {
  type      = string
  sensitive = true
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "enable_reader" {
  type    = bool
  default = false
}

variable "allowed_cidr_blocks" {
  description = "Your local IP to access DB — run: curl ifconfig.me"
  type        = list(string)
  default     = []
}