locals {
  tags = {
    Name       = var.domain_name
    Managed_By = "Terraform"
  }
  init_script = templatefile("${path.module}/cloud_init.sh.tpl", {
    domain_name = var.domain_name
    php_version = var.php_version
  })
}