locals {
  # Select AMI based on architecture: arm64 uses the Graviton AMI, x86_64 uses the amd64 AMI.
  ami_id = var.architecture == "arm64" ? data.aws_ami.ubuntu_arm64.image_id : data.aws_ami.ubuntu_amd64.image_id

  tags = {
    Name       = var.domain_name
    Managed_By = "Terraform"
  }

  # Resolve effective instance type: honour explicit caller override; otherwise
  # default to t4g.medium for arm64 (Graviton) and t3.medium for x86_64.
  effective_instance_type = var.instance_type != "t3.medium" ? var.instance_type : (
    var.architecture == "arm64" ? "t4g.medium" : "t3.medium"
  )

  init_script = templatefile("${path.module}/cloud_init.sh.tpl", {
    domain_name         = var.domain_name
    php_version         = var.php_version
    web_framework       = var.web_framework
    wordpress_hardening = var.wordpress_hardening
    # Always provided so templatefile() can parse the %{ if } block regardless of framework;
    # the conditional in the template controls whether they are emitted in the output.
    upstream_port  = var.upstream_port
    nodejs_version = var.nodejs_version
  })
}