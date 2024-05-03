module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = var.domain_name
  description = var.domain_name
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow ingress SSH"
      cidr_blocks = var.allow_ingress_ip
    }

  ]
  egress_rules = ["all-all"]

  tags = local.tags
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.6"

  name                        = var.domain_name
  ami                         = data.aws_ami.ubuntu.image_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.security_group.security_group_id]
  subnet_id                   = var.subnet_id
  user_data                   = data.template_file.init.rendered
  create_iam_instance_profile = var.create_iam_instance_profile
  root_block_device           = var.root_block_device
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
  tags = local.tags
}

resource "aws_eip" "this" {
  instance = module.ec2_instance.id
  domain   = "vpc"
  tags     = local.tags
}
