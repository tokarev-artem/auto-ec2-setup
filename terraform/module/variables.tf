variable "domain_name" {
  type        = string
  description = "Domain name to init instance for"
}

variable "instance_type" {
  default     = "t3.medium"
  description = "The instance type"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create instance and security group in"
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

variable "architecture" {
  type        = string
  description = "CPU architecture for the EC2 instance; valid values are x86_64 and arm64"
  default     = "x86_64"
  validation {
    condition     = contains(["x86_64", "arm64"], var.architecture)
    error_message = "architecture must be one of: \"x86_64\", \"arm64\"."
  }
}

variable "web_framework" {
  type        = string
  description = "Web framework to configure nginx for; valid values are php, nodejs, and static"
  default     = "php"
  validation {
    condition     = contains(["php", "nodejs", "static"], var.web_framework)
    error_message = "web_framework must be one of: \"php\", \"nodejs\", \"static\"."
  }
}

variable "upstream_port" {
  type        = number
  description = "Local TCP port that the Node.js process listens on (used when web_framework = \"nodejs\")"
  default     = 3000
  validation {
    condition     = var.upstream_port >= 1 && var.upstream_port <= 65535
    error_message = "upstream_port must be between 1 and 65535 (inclusive)."
  }
}

variable "nodejs_version" {
  type        = string
  description = "Node.js version to install via nvm when web_framework = \"nodejs\" (e.g. \"20\" for Node.js 20 LTS)"
  default     = "20"
}

variable "wordpress_hardening" {
  type        = bool
  description = "Whether to enable WordPress-specific nginx security rules (xmlrpc.php deny, readme/license 404, uploads PHP-execution deny)"
  default     = false
}

variable "install_mysql" {
  type        = bool
  description = "Whether to install MySQL and create databases/users"
  default     = true
}

variable "mysql_databases" {
  type = list(object({
    name     = string
    user     = string
    password = optional(string, "")
  }))
  description = <<-EOT
    List of MySQL databases and users to create. Each entry creates one database
    and one user with full privileges on that database.
    If password is omitted or empty, a random 20-character password is generated.
    Example:
      mysql_databases = [
        { name = "appdb",   user = "appuser" },
        { name = "testdb",  user = "testuser", password = "s3cr3t" }
      ]
  EOT
  default = []
}

variable "ubuntu_version" {
  type        = string
  description = "Ubuntu version"
  default     = "24.04"

  validation {
    condition     = contains(["22.04", "24.04", "26.04"], var.ubuntu_version)
    error_message = "Supported versions: 22.04, 24.04, 26.04."
  }
}

locals {
  ubuntu_codenames = {
    "22.04" = "jammy"
    "24.04" = "noble"
    "26.04" = "questing"
  }

  ubuntu_codename = local.ubuntu_codenames[var.ubuntu_version]
}