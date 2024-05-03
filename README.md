<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
## Usage
Basic usage of this module is as follows:
```hcl
  module "ec2" {
    source                      = "../module"
    instance_type               = "t3.medium"
    vpc_id                      = "vpc-abcdef123456"
    subnet_id                   = "subnet-abcdef123"
    allow_ingress_ip            = "0.0.0.0/0"
    create_iam_instance_profile = true
    php_version                 = "8.2"
    domain_name                 = "example.com"
    root_block_device = [
      {
        encrypted   = true
        volume_type = "gp3"
        throughput  = 200
        volume_size = 50
      },
    ]
  }
```
This project was created for 5 minutes ec2 instance setup with installed php, mysql, nginx, backups.
To run this project - you need to install [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 

Full working example you can find in terraform/example.com directory. Ajust parameters in main.tf and backend.tf files and run `terraform init` and `terraform apply`

After applying the Terraform configuration, an SSH key will be generated and saved in the directory from which you applied the code.

To connect to the server, use the following SSH command, replacing `<server_ip>` with the IP address of the server:
```bash
ssh <server_ip> -l ubuntu -i example.com.pem
```

After the server created - it will run self-setup ansible script used EC2 [user data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-shell-scripts)

## Ansible installation: 
- The PHP version to set up can be defined by the php_version parameter. Supported versions include 8.1, 8.2, and 8.3.
- The php.ini file will be configured to implement basic security changes.
- MySQL root and user password will be generated automatically, root password will be saved to `/root/.my.cnf`, user password will be saved to `/var/www/vhosts/example.com/index.php`.
- A MySQL backup script will be installed to `/root/bin/mysql-maint.sh` and added as a cronjob to execute at midnight.
- An Nginx configuration file will be created at /etc/nginx/conf.d/example.com.conf, and the virtual host will be served from /var/www/vhosts/example.com/.
- After the autosetup is finished, you can point the DNS of your example.com and www.example.com to the IP address and issue HTTPS certificates by running certbot --nginx.

## Debug: 
If something was not configured properly - you can review ansible log in /var/log/cloud-init-output.log.

## Resources

| Name | Type |
|------|------|
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [local_file.cloud_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [template_file.init](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_ingress_ip"></a> [allow\_ingress\_ip](#input\_allow\_ingress\_ip) | IP address to allow ssh access to | `string` | n/a | yes |
| <a name="input_create_iam_instance_profile"></a> [create\_iam\_instance\_profile](#input\_create\_iam\_instance\_profile) | Determines whether an IAM instance profile is created or to use an existing IAM instance profile | `bool` | `false` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Domain name to init instance for | `string` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type | `string` | `"t3.medium"` | no |
| <a name="input_php_version"></a> [php\_version](#input\_php\_version) | PHP version to install | `string` | `"8.1"` | no |
| <a name="input_root_block_device"></a> [root\_block\_device](#input\_root\_block\_device) | Root block device parameters | `any` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | VPC subnet id to create the instance in | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to create instance and security group in | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ec2_instance_id"></a> [ec2\_instance\_id](#output\_ec2\_instance\_id) | EC2 instance ID |
| <a name="output_ec2_instance_ip"></a> [ec2\_instance\_ip](#output\_ec2\_instance\_ip) | EC2 public IP |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | EC2 instance security group ID |
| <a name="output_ssh_key_name"></a> [ssh\_key\_name](#output\_ssh\_key\_name) | SSH key name |
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->