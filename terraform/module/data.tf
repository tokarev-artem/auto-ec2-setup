data "template_file" "init" {
  template = file("${path.module}/cloud_init.sh.tpl")

  vars = {
    domain_name = var.domain_name
    php_version = var.php_version
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}