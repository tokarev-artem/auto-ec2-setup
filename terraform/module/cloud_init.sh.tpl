#!/bin/bash

set -euxo pipefail

echo "STEP 1 - before repo"
apt-add-repository ppa:ansible/ansible
apt-get update -y
apt-get install -y ansible git snapd jq

echo "STEP 2 - clone repo"
cd /root
git clone https://github.com/tokarev-artem/auto-ec2-setup.git -b v2
cd auto-ec2-setup/ansible/

echo "STEP 3 - create tmp file"
# Write mysql_databases JSON to a file. Terraform renders the value as a
# single-line JSON string; printf writes it without shell interpretation.
printf '%s\n' '${mysql_databases}' > /tmp/mysql_vars.json

echo "STEP 4 - create eextra vars"
EXTRA_VARS="domain_name=${domain_name} php_version=${php_version} web_framework=${web_framework} wordpress_hardening=${wordpress_hardening} install_mysql=${install_mysql}"
%{ if web_framework == "nodejs" }
EXTRA_VARS="$EXTRA_VARS upstream_port=${upstream_port} nodejs_version=${nodejs_version}"
%{ endif }

echo "STEP 5 - run ansible playbook"
ansible-playbook setup.yml --extra-vars "$$EXTRA_VARS" --extra-vars "@/tmp/mysql_vars.json"
