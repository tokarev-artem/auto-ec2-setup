output "security_group_id" {
  value       = module.security_group.security_group_id
  description = "EC2 instance security group ID"
}
output "ec2_instance_ip" {
  value       = aws_eip.this.public_ip
  description = "EC2 public IP"
}
output "ec2_instance_id" {
  value       = module.ec2_instance.id
  description = "EC2 instance ID"
}
output "ssh_key_name" {
  value       = "${var.domain_name}.pem"
  description = "SSH key name"
}