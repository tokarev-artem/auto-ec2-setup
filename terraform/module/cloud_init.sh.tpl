#!/bin/bash
set -x

apt-add-repository ppa:ansible/ansible
echo "Install tools"
apt update
apt install ansible git python3-pip snapd -yqqq

echo "Fetch the setup repository"
cd /root && git clone https://github.com/tokarev-artem/auto-ec2-setup.git -b v2 && cd auto-ec2-setup/ansible/

echo "Setup the server"

# Write mysql_databases JSON to a file so it is not mangled by shell quoting.
# ansible-playbook loads it with @/tmp/mysql_vars.json.
cat > /tmp/mysql_vars.json << 'JSONEOF'
${mysql_databases}
JSONEOF

EXTRA_VARS="domain_name=${domain_name} php_version=${php_version} web_framework=${web_framework} wordpress_hardening=${wordpress_hardening} install_mysql=${install_mysql}"

%{ if web_framework == "nodejs" }
EXTRA_VARS="$$EXTRA_VARS upstream_port=${upstream_port} nodejs_version=${nodejs_version}"
%{ endif }

echo "Running ansible-playbook"
ansible-playbook setup.yml --extra-vars "$$EXTRA_VARS" --extra-vars @/tmp/mysql_vars.json
