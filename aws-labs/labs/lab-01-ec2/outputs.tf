output "instance_id" {
  value = module.ec2.instance_id
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "ssh_command" {
  description = "SSH vào EC2"
  value       = "ssh -i ~/.ssh/id_rsa ec2-user@${module.ec2.public_ip}"
}

output "web_url" {
  description = "URL web server"
  value       = "http://${module.ec2.public_ip}"
}