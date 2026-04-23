variable "project_name" { // tên project
  description = "Project name for naming resources"
  type        = string
}

variable "engine_version" {
  description = "Aurora MySQL version"
  type = string 
  default = "8.0.mysql_aurora.3.04.0"
}

variable "database_name" {
  description = "Initial database name"
  type = string 
  default = "admindb"
}

variable "master_username" {
  description = "Master DB username"
  type = string 
  default = "admin"
}

variable "master_password" {
  description = "Master DB password"
  type = string 
  sensitive = true 
}

variable "backup_retention_days" {
  description = "Days to retain automated backups"
  type        = number
  default     = 1
}

variable "instance_class" {
  description = "Instance class for Aurora"
  type = string 
  default = "db.t3.medium"
}

variable "publicly_accessible" {
  description = "Make instance publicly accessiable (lab only)"
  type = bool 
  default = false 
}

variable "enable_reader" {
  description = "Create a read replica instance"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "List of subnets IDs (minimum 2, diff AZs)"
  type = list(string)
}

variable "vpc_id" {
  description = "VPC ID where RDS will be deployed"
  type        = string
}

variable "allowed_cidr_blocks" { // IP được phép SSH vào
  description = "CIDRS allowed connect on port 3306"
  type        = list(string)  // Kiểu dữ liệu là danh sách các chuỗi
  default     = [] 
}

variable "allowed_security_group_ids" {
  description = "Security group IDs allowed to connect"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
