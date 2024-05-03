resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "cloud_pem" {
  filename        = "${var.domain_name}.pem"
  file_permission = "0600"
  content         = tls_private_key.this.private_key_pem
}

resource "aws_key_pair" "this" {
  key_name   = var.domain_name
  public_key = tls_private_key.this.public_key_openssh
}
