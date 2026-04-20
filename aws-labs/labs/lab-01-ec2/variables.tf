variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "project_name" { // tên project
  description = "Project name for naming resources"
  type        = string
}

variable "allowed_cidr_blocks" { // IP được phép SSH vào
  description = "CIDRS allowed to SSH in"
  type        = list(string)  // Kiểu dữ liệu là danh sách các chuỗi
  default     = ["0.0.0.0/0"] // Mặc định cho phép tất cả
}

variable "common_tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "public_key_path" {
  description = "Path to local SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0df7a207adb9748c7" // Amazon Linux 2023 AMI
}

variable "instance_type" {
  description = "Instance type for EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}
