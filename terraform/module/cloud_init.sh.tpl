#!/bin/bash

set -euxo pipefail

echo "STEP 1 - before repo"
apt-add-repository ppa:ansible/ansible
apt-get update -yqq
apt-get install -yqq ansible git snapd jq

echo "STEP 2 - clone repo"
cd /root
git clone https://github.com/tokarev-artem/auto-ec2-setup.git -b v2
cd auto-ec2-setup/ansible/

echo "STEP 3 - create tmp file"
printf '%s\n' '${mysql_databases}' > /tmp/mysql_vars.json

echo "STEP 4 - create extra vars"
# Extra vars are now passed as JSON from Terraform - much more reliable
cat > /tmp/extra_vars.json << 'EOF'
${extra_vars_json}
EOF

echo "STEP 5 - run ansible playbook"
ansible-playbook setup.yml \
  --extra-vars "@/tmp/extra_vars.json" \
  --extra-vars "@/tmp/mysql_vars.json"