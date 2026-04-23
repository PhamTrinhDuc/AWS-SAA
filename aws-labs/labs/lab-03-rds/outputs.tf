output "writer_endpoint" {
  value = module.aurora.cluster_endpoint
}

output "reader_endpoint" {
  value = module.aurora.cluster_reader_endpoint
}

output "database_name" {
  value = module.aurora.database_name
}

output "port" {
  value = module.aurora.port
}

output "mysql_command" {
  description = "Kết nối từ terminal"
  value = "mysql -h ${module.aurora.cluster_endpoint} -P ${module.aurora.port} -u admin -p"
}

output "ssm_password_path" {
  description = "Lấy password từ SSM"
  value       = module.aurora.ssm_password_path
}