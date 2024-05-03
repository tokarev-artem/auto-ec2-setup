locals {
  tags = {
    Name       = var.domain_name
    Managed_By = "Terraform"
  }
}
