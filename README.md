<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
## Requirements

No requirements.
## Usage
Basic usage of this module is as follows:
```hcl
  module "ec2" {
    source                      = "../module"
    domain_name                 = "example.com"
    vpc_id                      = "vpc-abcdef123456"
    subnet_id                   = "subnet-abcdef123"
    allow_ingress_ip            = "0.0.0.0/0"
    create_iam_instance_profile = true

    # Architecture: "x86_64" (default) or "arm64" (Graviton).
    # instance_type is resolved automatically unless overridden:
    #   x86_64 → t3.medium, arm64 → t4g.medium
    architecture = "arm64"
    # instance_type = "t3.medium" # uncomment to override the auto-resolved type

    # Web framework: "php" (default), "nodejs", "proxy" or "static"
    web_framework = "php"
    php_version   = "8.4"

    # Node.js options — only used when web_framework = "nodejs"
    # web_framework   = "nodejs"
    # nodejs_version  = "20"
    # upstream_port   = 3000

    # MySQL: set install_mysql = false to skip MySQL entirely.
    # mysql_databases defines which databases and users to create.
    # Random password will be set.
    install_mysql = true
    mysql_databases = [
      { name = "appdb", user = "appuser" },
      { name = "testdb", user = "testuser" },
    ]
    ubuntu_lts_version = "24.04"

    root_block_device = ({
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      }
    )
  }
```
This project was created for 5 minutes ec2 instance setup with installed php, mysql, nginx, nodejs, backups.
To run this project - you need to install [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) 

Full working example you can find in terraform/example.com directory. Ajust parameters in main.tf and backend.tf files and run `terraform init` and `terraform apply`

After applying the Terraform configuration, an SSH key will be generated and saved in the directory from which you applied the code.

To connect to the server, use the following SSH command, replacing `<server_ip>` with the IP address of the server:
```bash
ssh <server_ip> -l ubuntu -i example.com.pem
```

After the server created - it will run self-setup ansible script used EC2 [user data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html#user-data-shell-scripts)

## Ansible installation: 
- The PHP version to set up can be defined by the php_version parameter. Supported versions include 8.3, 8.4 and 8.5
- The php.ini file will be configured to implement basic security changes.
- MySQL root and user password will be generated automatically, root password will be saved to `/root/.my.cnf`, user password will be saved to `/var/www/vhosts/<dbname>/.db_credentials`.
- Backup user will be created with read-only access to the database.
- A MySQL backup script will be installed to `/root/bin/mysql-maint.sh` and added as a cronjob to execute at midnight.
- An Nginx configuration file will be created at /etc/nginx/conf.d/example.com.conf, and the virtual host will be served from /var/www/vhosts/example.com/.
- After the autosetup is finished, you can point the DNS of your example.com and www.example.com to the IP address and issue HTTPS certificates by running certbot --nginx.

## Debug: 
If something was not configured properly - you can review ansible log in /var/log/cloud-init-output.log.

## Resources

No resources.
## Inputs

No inputs.
## Outputs

No outputs.
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->