variable "domain_name" {
  type        = string
  description = "Domain name to init instance for"
}
variable "instance_type" {
  default     = "t3.medium"
  description = "The instance type"
}
variable "vpc_id" {
  description = "VPC ID to create instance and security group in"
  type        = string
}
variable "subnet_id" {
  description = "VPC subnet id to create the instance in"
}
variable "allow_ingress_ip" {
  type        = string
  description = "IP address to allow ssh access to"
}
variable "create_iam_instance_profile" {
  type        = bool
  description = "Determines whether an IAM instance profile is created or to use an existing IAM instance profile"
  default     = false
}
variable "php_version" {
  type        = string
  description = "PHP version to install"
  default     = "8.1"
}
variable "root_block_device" {
  type        = any
  description = "Root block device parameters"
}