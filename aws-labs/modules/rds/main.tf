# -------------------------------------------
# Subnet Group — Aurora cần ít nhất 2 AZ
# -------------------------------------------
resource "aws_db_subnet_group" "this" {
  name = "${var.project_name}-subnet-group"
  description = "Subnet group for ${var.project_name}"
  subnet_ids = var.subnet_ids

  tags = var.common_tags
}

# -------------------------------------------
# Security Group — chỉ cho phép EC2 hoặc CIDR nội bộ
# -------------------------------------------
resource "aws_security_group" "this" {
  name = "${var.project_name}-rds-sg"
  description = "Allow MySQL access"
  vpc_id = var.vpc_id // VPC ID đề làm gì??? 

  ingress {
    description = "MySQL from allowed resources"
    from_port = 3306
    to_port = 3306 
    protocol = "tcp"
    cidr_blocks = var.allowed_cidr_blocks 
    security_groups = var.allowed_security_group_ids
  }

  egress {
    from_port = 0 
    to_port = 0 
    protocol = "1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

# -------------------------------------------
# Aurora Cluster
# -------------------------------------------
resource "aws_rds_cluster" "this" {
  cluster_identifier = "${var.project_name}-cluster"
  engine = "aurora-mysql"
  engine_version = var.engine_version
  database_name = var.database_name
  master_username = var.master_username
  master_password = var.master_password 
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [ aws_security_group.this.id ]

  # Backup 
  backup_retention_period = var.backup_retention_days
  preferred_backup_window = "02:00-03:00"

  # Maintenance 
  preferred_maintenance_window = "sun:04:00-sun:05:00"

  # Encryption at rest 
  storage_encrypted = true

  # Delete easy to lab (not use in production)
  skip_final_snapshot = true 
  deletion_protection = false 

  tags = var.common_tags
}

# -------------------------------------------
# Aurora Instances (writer + optional reader)
# -------------------------------------------
resource "aws_rds_cluster_instance" "writer" {
  identifier = "${var.project_name}-writer"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class = var.instance_class 
  engine = aws_rds_cluster.this.engine
  engine_version = aws_rds_cluster.this.engine_version

  publicly_accessible = var.publicly_accessible 
  db_subnet_group_name = aws_db_subnet_group.this.name

  tags = merge(var.common_tags, {
    Role = "writer"
  })
}

resource "aws_rds_cluster_instance" "reader" {
  count = var.enable_reader ? 1 : 0
  
  identifier = "${var.project_name}-writer"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class = var.instance_class 
  engine = aws_rds_cluster.this.engine
  engine_version = aws_rds_cluster.this.engine_version

  publicly_accessible = var.publicly_accessible 
  db_subnet_group_name = aws_db_subnet_group.this.name

  tags = merge(var.common_tags, {
    Role = "reader"
  })
}

# -------------------------------------------
# SSM Parameter Store — lưu password an toàn
# -------------------------------------------
resource "aws_ssm_parameter" "db_password" {
  name = "/${var.project_name}/db/password"
  description = "Aurora master password"
  type = "SecureString"
  value = var.master_password

  tags = var.common_tags
}

resource "aws_ssm_parameter" "db_endpoint" {
  name = "/${var.project_name}/db/endpoint"
  description = "Aurora cluster endpoint"
  type = "SecureString"
  value = aws_rds_cluster.this.endpoint

  tags = var.common_tags
}