module "ec2" {
  source                      = "../module"
  domain_name                 = "example.com"
  vpc_id                      = "vpc-00e5f8f46b05ac6ab"
  subnet_id                   = "subnet-0fbbb2109e38ee993"
  allow_ingress_ip            = "12.23.45.67/32"
  create_iam_instance_profile = true

  # Architecture: "x86_64" (default) or "arm64" (Graviton).
  # instance_type is resolved automatically unless overridden:
  #   x86_64 → t3.medium, arm64 → t4g.medium
  architecture = "arm64"
  # instance_type = "t3.medium" # uncomment to override the auto-resolved type

  # Web framework: "php" (default), "nodejs", "proxy" or "static"
  web_framework = "php"
  php_version   = "8.4"

  # Node.js options — only used when web_framework = "nodejs"
  # web_framework   = "nodejs"
  # nodejs_version  = "20"
  # upstream_port   = 3000

  # MySQL: set install_mysql = false to skip MySQL entirely.
  # mysql_databases defines which databases and users to create.
  # Random password will be set.
  install_mysql = true
  mysql_databases = [
    { name = "appdb", user = "appuser" },
    { name = "testdb", user = "testuser" },
  ]
  ubuntu_lts_version = "24.04"

  root_block_device = ({
    encrypted   = true
    volume_type = "gp3"
    throughput  = 200
    volume_size = 50
    }
  )
}

output "all" {
  value = module.ec2
}
