module "ec2" {
  source                      = "../module"
  domain_name                 = "example.com"
  vpc_id                      = "vpc-abcdef123456"
  subnet_id                   = "subnet-abcdef123456"
  allow_ingress_ip            = "0.0.0.0/0"
  create_iam_instance_profile = true

  # Architecture: "x86_64" (default) or "arm64" (Graviton).
  # instance_type is resolved automatically unless overridden:
  #   x86_64 → t3.medium, arm64 → t4g.medium
  architecture = "x86_64"
  # instance_type = "t3.medium"   # uncomment to override the auto-resolved type

  # Web framework: "php" (default), "nodejs", or "static"
  web_framework = "php"
  php_version   = "8.2"

  # Node.js options — only used when web_framework = "nodejs"
  # web_framework   = "nodejs"
  # nodejs_version  = "20"
  # upstream_port   = 3000

  # WordPress hardening: adds xmlrpc.php deny, readme/license 404,
  # and uploads/files/storage PHP-execution deny blocks to nginx.
  # Set to true for WordPress sites; false (default) for everything else.
  wordpress_hardening = false

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
    },
  ]
}

output "all" {
  value = module.ec2
}
