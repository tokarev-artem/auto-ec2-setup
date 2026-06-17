module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 6.0"

  name        = var.domain_name
  description = var.domain_name
  vpc_id      = var.vpc_id

  ingress_rules = {
    http = {
      from_port   = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTP from anywhere"
    }
    https = {
      from_port   = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTPS from anywhere"
    }
    ssh = {
      from_port   = 22
      ip_protocol = "tcp"
      cidr_ipv4   = var.allow_ingress_ip
      description = "SSH from allowed IP"
    }
  }
  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = local.tags
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.0"

  name                        = var.domain_name
  ami                         = local.ami_id
  instance_type               = local.effective_instance_type
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.security_group.id]
  subnet_id                   = var.subnet_id
  user_data                   = local.init_script
  create_iam_instance_profile = var.create_iam_instance_profile
  root_block_device           = var.root_block_device
  create_eip                  = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  tags = local.tags
}
