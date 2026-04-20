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
}

variable "instance_type" {
  description = "Instance type for EC2 instance"
  type        = string
}
