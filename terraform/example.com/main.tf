module "ec2" {
  source                      = "../module"
  domain_name                 = "example.com"
  instance_type               = "t3.medium"
  vpc_id                      = "vpc-abcdef123456"
  subnet_id                   = "subnet-abcdef123456"
  allow_ingress_ip            = "0.0.0.0/0"
  create_iam_instance_profile = true
  php_version                 = "8.2"
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
