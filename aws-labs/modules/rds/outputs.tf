output "cluster_endpoint" {
  description = "Writer endpoint"
  value       = aws_rds_cluster.this.endpoint
}

output "cluster_reader_endpoint" {
  description = "Reader endpoint (load balanced)"
  value       = aws_rds_cluster.this.reader_endpoint
}

output "cluster_id" {
  value = aws_rds_cluster.this.id
}

output "database_name" {
  value = aws_rds_cluster.this.database_name
}

output "port" {
  value = aws_rds_cluster.this.port
}

output "security_group_id" {
  value = aws_security_group.rds.id
}

output "ssm_password_path" {
  description = "SSM path to retrieve password"
  value       = aws_ssm_parameter.db_password.name
}